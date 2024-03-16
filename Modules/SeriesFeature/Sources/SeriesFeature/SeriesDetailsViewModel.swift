import Foundation

final class SeriesDetailsViewModel: ObservableObject {
  private let service: DetailsService
  private let id: Int
  private let repository: SeriesRepositoryInterface

  @Published var seriesDetails: SeriesDetails?
  @Published var seasons: [SeriesDetails.Season] = []
  @Published var providers: [WatchProvider] = []
  @Published var similarSeries: [Series] = []
  @Published var recommendatedSeries: [Series] = []
  
  init(
    id: Int,
    service: DetailsService,
    repository: SeriesRepositoryInterface
  ) {
    self.service = service
    self.id = id
    self.repository = repository

    fetchSeriesDetails()
  }
  
  func fetchSeriesDetails() {
    Task { @MainActor in
      do {
        seriesDetails = try await service.fetchSeriesDetails(id: id)
        similarSeries = seriesDetails?.similar?.results ?? []
        recommendatedSeries = seriesDetails?.recommendations?.results ?? []
        seasons = seriesDetails?.seasons ?? []
        generateProviders(for: seriesDetails?.watchProviders)
      } catch {
        print(error)
      }
    }
  }
  
  func generateProviders(for response: WatchProviderResponse?) {
    let buy = response?.results.US?.buy ?? []
    let flatrate = response?.results.US?.flatrate ?? []
    let rent = response?.results.US?.rent ?? []
    providers = Array(Set(buy + flatrate + rent)).sorted(by: { $0.displayPriority < $1.displayPriority } )
  }
  
  func addSeriesToWatchlist() {
    guard let series = seriesDetails else { return }
    _ = repository.create(series: series)
  }
  
  var watchlistIconName: String {
    guard let seriesDetails = seriesDetails else {
      return "bookmark"
    }
    
    let result = repository.getSeries(
      predicate: NSPredicate(
        format: "id == %@", String(describing: seriesDetails.id)
      )
    )
    switch result {
    case .success(let series):
      return series.isEmpty ? "bookmark" : "bookmark.fill"
    case .failure:
      return "bookmark"
    }
  }
}
