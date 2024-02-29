import Foundation

public final class MoviesDetailsViewModel: ObservableObject {
  private let service: Service
  private let movie: Movie
  @Published var details: MovieDetails?
  @Published var providers: [WatchProvider] = []
  @Published var similarMovies: [Movie] = []
  @Published var recommendatedMovies: [Movie] = []
  
  public init(movie: Movie, service: Service) {
    self.service = service
    self.movie = movie
  }
  
  func fetchMovieDetails() {
    Task { @MainActor in
      do {
        details = try await service.fetchMovieDetails(id: movie.id)
        similarMovies = details?.similar.results ?? []
        recommendatedMovies = details?.recommendations.results ?? []
        generateProviders()
      } catch {
        print(error)
      }
    }
  }
  
  func generateProviders() {
    let buy = details?.watchProviders.results.US?.buy ?? []
    let flatrate = details?.watchProviders.results.US?.buy ?? []
    let rent = details?.watchProviders.results.US?.buy ?? []
    providers = Array(Set(buy + flatrate + rent)).sorted(by: { $0.displayPriority < $1.displayPriority } )
  }
}
