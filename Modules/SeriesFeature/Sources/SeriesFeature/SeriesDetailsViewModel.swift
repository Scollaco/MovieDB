import Foundation

public final class SeriesDetailsViewModel: ObservableObject {
  private let service: DetailsService
  private let id: Int
  
  @Published var seriesDetails: SeriesDetails?
  @Published var seasons: [SeriesDetails.Season] = []
  @Published var providers: [WatchProvider] = []
  @Published var similarSeries: [Series] = []
  @Published var recommendedSeries: [Series] = []
  
  @Published var providersSectionIsVisible: Bool = false
  @Published var taglineIsVisible: Bool = false
  @Published var similarSectionIsVisible: Bool = false
  @Published var recommendedSectionIsVisible: Bool = false
  @Published var seasonsSectionIsVisible: Bool = false
  
  public init(id: Int, service: DetailsService) {
    self.service = service
    self.id = id
    fetchSeriesDetails()
  }
  
  func fetchSeriesDetails() {
    Task { @MainActor in
      do {
        seriesDetails = try await service.fetchSeriesDetails(id: id)
        let tagline = seriesDetails?.tagline
        taglineIsVisible = tagline != nil && !(tagline?.isEmpty ?? true)
        
        similarSeries = seriesDetails?.similar?.results ?? []
        similarSectionIsVisible = !similarSeries.isEmpty
        
        recommendedSeries = seriesDetails?.recommendations?.results ?? []
        recommendedSectionIsVisible = !recommendedSeries.isEmpty
        
        seasons = seriesDetails?.seasons ?? []
        seasonsSectionIsVisible = !seasons.isEmpty
        
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
    providersSectionIsVisible = !providers.isEmpty
  }
}
