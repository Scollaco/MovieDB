import Foundation

final class MovieDetailsViewModel: ObservableObject {
  private let service: DetailsService
  private let id: Int
  private let repository: MovieRepositoryInterface

  @Published var movieDetails: MovieDetails?
  @Published var providers: [WatchProvider] = []
  @Published var similarMovies: [Movie] = []
  @Published var recommendatedMovies: [Movie] = []
  @Published var watchlistIconName: String = .init()
  
  init(
    id: Int,
    service: DetailsService,
    repository: MovieRepositoryInterface
  ) {
    self.service = service
    self.id = id
    self.repository = repository
    watchlistIconName = isWatchlisted ? "bookmark.fill" : "bookmark"
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
  
  func addMovieToWatchlist() {
    guard let movie = movieDetails else { return }
    guard !isWatchlisted else {
      _ = repository.delete(movie: movie)
      watchlistIconName = "bookmark"
      return
    }
    _ = repository.create(movie: movie)
    watchlistIconName = "bookmark.fill"
  }
  
  private var isWatchlisted: Bool {
    guard let movieDetails = movieDetails else {
      return false
    }
    
    let result = repository.getMovies(
      predicate: NSPredicate(
        format: "id == %@", String(describing: movieDetails.id)
      )
    )
    switch result {
    case .success(let movie):
      return movie.isEmpty ? false : true
    case .failure:
      return false
    }
  }
}
