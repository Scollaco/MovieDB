import Foundation

public final class SeriesDetailsViewModel: ObservableObject {
  private let service: DetailsService
  private let id: Int
  
  @Published var seriesDetails: SeriesDetails?
  @Published var seasons: [SeriesDetails.Season] = []
  @Published var providers: [WatchProvider] = []
  @Published var similarSeries: [Series] = []
  @Published var recommendatedSeries: [Series] = []
  
  public init(id: Int, service: DetailsService) {
    self.service = service
    self.id = id
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
}
