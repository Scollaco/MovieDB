import Foundation

public final class MovieDetailsViewModel: ObservableObject {
  private let service: DetailsService
  private let id: Int
  
  @Published var movieDetails: MovieDetails?
  @Published var providers: [WatchProvider] = []
  @Published var similarMovies: [Movie] = []
  @Published var recommendatedMovies: [Movie] = []
  
  public init(id: Int, service: DetailsService) {
    self.service = service
    self.id = id
    fetchMovieDetails()
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
