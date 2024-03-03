import Foundation

public final class SeriesDetailsViewModel: ObservableObject {
  private let service: Service
  private let series: Series
  @Published var details: SeriesDetails?
  @Published var seasons: [SeriesDetails.Season] = []
  @Published var providers: [WatchProvider] = []
  @Published var similarSeries: [Series] = []
  @Published var recommendatedSeries: [Series] = []
  
  public init(series: Series, service: Service) {
    self.service = service
    self.series = series
  }
  
  func fetchSeriesDetails() {
    Task { @MainActor in
      do {
        details = try await service.fetchSeriesDetails(id: series.id)
        similarSeries = details?.similar?.results ?? []
        recommendatedSeries = details?.recommendations?.results ?? []
        seasons = details?.seasons ?? []
        generateProviders()
      } catch {
        print(error)
      }
    }
  }
  
  func generateProviders() {
    let buy = details?.watchProviders?.results.US?.buy ?? []
    let flatrate = details?.watchProviders?.results.US?.buy ?? []
    let rent = details?.watchProviders?.results.US?.buy ?? []
    providers = Array(Set(buy + flatrate + rent)).sorted(by: { $0.displayPriority < $1.displayPriority } )
  }
}
