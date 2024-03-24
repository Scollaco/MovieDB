import Foundation

public final class DetailsViewModel: ObservableObject {
  private let service: Service
  private let id: Int
  private let repository: DetailsRepository?
  
  @Published var seriesDetails: SeriesDetails?
  @Published var movieDetails: MovieDetails?
  @Published var seasons: [SeriesDetails.Season] = []
  @Published var providers: [WatchProvider] = []
  @Published var similarSeries: [Details] = []
  @Published var recommendatedSeries: [Details] = []
  @Published var similarMovies: [Details] = []
  @Published var recommendatedMovies: [Details] = []
  
  public init(
    id: Int,
    mediaType: String,
    service: Service,
    repository: DetailsRepository?
  ) {
    self.service = service
    self.id = id
    self.repository = repository
    guard let type = MediaType(rawValue: mediaType) else { return }
    
    switch type {
    case .movie:
      fetchMovieDetails()
    case .tv:
      fetchSeriesDetails()
    }
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
  
  func fetchMovieDetails() {
    Task { @MainActor in
      do {
        movieDetails = try await service.fetchMovieDetails(id: id)
        similarMovies = movieDetails?.similar.results ?? []
        recommendatedMovies = movieDetails?.recommendations.results ?? []
        generateProviders(for: movieDetails?.watchProviders)
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
