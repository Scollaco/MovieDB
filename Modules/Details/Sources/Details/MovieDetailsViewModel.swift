import Foundation

final class MovieDetailsViewModel: ObservableObject {
  enum Icon: String {
    case bookmark = "bookmark.circle"
    case bookmarkFill = "bookmark.circle.fill"
  }
  
  private let service: MovieDetailsServiceInterface
  private let id: Int
  private let repository: MovieRepositoryInterface

  @Published var movieDetails: MovieDetails?
  @Published var providers: [WatchProvider] = []
  @Published var similarMovies: [Details] = []
  @Published var recommendatedMovies: [Details] = []
  @Published var reviews: [Review] = []
  @Published var watchlistIconName: String = Icon.bookmark.rawValue
  @Published var reviewsSectionIsVisible: Bool = false

  init(
    id: Int,
    service: MovieDetailsServiceInterface,
    repository: MovieRepositoryInterface
  ) {
    self.service = service
    self.id = id
    self.repository = repository
    fetchMovieDetails()
  }
  
  func fetchMovieDetails() {
    Task { @MainActor in
      do {
        movieDetails = try await service.fetchMovieDetails(id: id)
        similarMovies = movieDetails?.similar.results ?? []
        recommendatedMovies = movieDetails?.recommendations.results ?? []
        generateProviders(for: movieDetails?.watchProviders)
        watchlistIconName = isWatchlisted ? Icon.bookmarkFill.rawValue : Icon.bookmark.rawValue
        reviews = movieDetails?.reviews ?? []
        reviewsSectionIsVisible = !reviews.isEmpty
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
      watchlistIconName = Icon.bookmark.rawValue
      return
    }
    _ = repository.create(movie: movie)
    watchlistIconName = Icon.bookmarkFill.rawValue
  }
  
  private var isWatchlisted: Bool {
    guard let movieDetails = movieDetails,
          let _ = repository.getMovie(with: movieDetails.id) else {
      return false
    }
    return true
  }
}
