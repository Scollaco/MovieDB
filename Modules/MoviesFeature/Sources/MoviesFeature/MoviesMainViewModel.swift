import Foundation

public final class MoviesMainViewModel: ObservableObject {
  enum ViewState {
    case loading
    case normal
  }
  
  private let service: Service
  private var viewState: ViewState = .normal
  @Published var nowPlayingMovies: [Movie] = []
  @Published var popularMovies: [Movie] = []
  @Published var topRatedMovies: [Movie] = []
  @Published var upcomingMovies: [Movie] = []
  
  private var nextNowPlayingPage = 1
  private var nextPopularPage = 1
  private var nextTopRatedPage = 1
  private var nextUpcomingPage = 1
  
  public init(service: Service) {
    self.service = service
    fetchMovies()
  }
  
  func fetchMovies() {
    Task { @MainActor in
      do {
        try await fetchNowPlayingMovies()
        try await fetchPopularMovies()
        try await fetchTopRatedMovies()
        try await fetchUpcomingMovies()
      } catch {
        print(error)
      }
    }
  }
  
  @MainActor
  func fetchPopularMovies() async throws {
    let popularResponse = try await service.fetchMovies(category: .popular, page: nextPopularPage)
    nextPopularPage = popularResponse.page + 1
    let movies = popularResponse
      .results
      .sorted(by: { $0.voteAverage > $1.voteAverage})
    popularMovies.append(contentsOf: movies)
  }
  
  @MainActor
  func fetchNowPlayingMovies() async throws {
    let nowPlayingResponse = try await service.fetchMovies(category: .nowPlaying, page: nextNowPlayingPage)
    nextNowPlayingPage = nowPlayingResponse.page + 1
    let movies = nowPlayingResponse
      .results
      .sorted(by: { $0.voteAverage > $1.voteAverage})
    nowPlayingMovies.append(contentsOf: movies)
  }
  
  @MainActor
  func fetchTopRatedMovies() async throws {
    guard viewState == .normal else { return }
    viewState = .loading
    let topRatedResponse = try await service.fetchMovies(category: .topRated, page: nextTopRatedPage)
    nextTopRatedPage = topRatedResponse.page + 1
    let movies = topRatedResponse
      .results
      .sorted(by: { $0.voteAverage > $1.voteAverage})
    topRatedMovies.append(contentsOf: movies)
    viewState = .normal
  }
  
  @MainActor
  func fetchUpcomingMovies() async throws {
    guard viewState == .normal else { return }
    viewState = .loading
    let upcomingMoviesResponse = try await service.fetchMovies(category: .upcoming, page: nextUpcomingPage)
    nextUpcomingPage = upcomingMoviesResponse.page + 1
    let movies = upcomingMoviesResponse
      .results
      .sorted(by: { $0.voteAverage > $1.voteAverage})
    upcomingMovies.append(contentsOf: movies)
    viewState = .normal
  }
  
  func shouldLoadMoreData(_ movieId: Int, items: [Movie]) -> Bool {
    // Fetch more data when list is approaching the end
    let targetItem = items.count >= 6 ? items[items.count - 5] : items.last
    return movieId == targetItem?.id
  }
  
  func loadMoreData(for category: Category) {
    Task { @MainActor in
      switch category {
      case .nowPlaying:
        try? await fetchNowPlayingMovies()
      case .popular:
        try? await fetchPopularMovies()
      case .topRated:
        try? await fetchTopRatedMovies()
      case .upcoming:
        try? await fetchUpcomingMovies()
      }
    }
  }
}
