import Foundation
import Utilities

final class MoviesMainViewModel: ObservableObject {
  private let service: Service

  @Published var trendingMovies: [Movie] = []
  @Published var nowPlayingMovies: [Movie] = []
  @Published var popularMovies: [Movie] = []
  @Published var topRatedMovies: [Movie] = []
  @Published var upcomingMovies: [Movie] = []
  
  private(set) var nextTrendingPage = 1
  private(set) var nextNowPlayingPage = 1
  private(set) var nextPopularPage = 1
  private(set) var nextTopRatedPage = 1
  private(set) var nextUpcomingPage = 1
  
  init(service: Service) {
    self.service = service
    fetchMovies()
  }
  
  func fetchMovies() {
    Task {
      do {
        try await fetchTrendingMovies()
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
  private func fetchTrendingMovies() async throws {
    let trendingResponse = try await service.fetchTrendingMovies(
      page: nextTrendingPage,
      timeWindow: .week
    )
    nextTrendingPage = trendingResponse.page + 1
    let movies = trendingResponse
      .results
    trendingMovies.append(contentsOf: movies)
  }
  
  @MainActor
  private func fetchPopularMovies() async throws {
    let popularResponse = try await service.fetchMovies(section: .popular, page: nextPopularPage)
    nextPopularPage = popularResponse.page + 1
    let movies = popularResponse
      .results
      .shuffled()
    popularMovies.append(contentsOf: movies)
  }
  
  @MainActor
  private func fetchNowPlayingMovies() async throws {
    let nowPlayingResponse = try await service.fetchMovies(section: .nowPlaying, page: nextNowPlayingPage)
    nextNowPlayingPage = nowPlayingResponse.page + 1
    let movies = nowPlayingResponse
      .results
      .shuffled()
    nowPlayingMovies.append(contentsOf: movies)
  }
  
  @MainActor
  private func fetchTopRatedMovies() async throws {
    let topRatedResponse = try await service.fetchMovies(section: .topRated, page: nextTopRatedPage)
    nextTopRatedPage = topRatedResponse.page + 1
    let movies = topRatedResponse
      .results
      .shuffled()
    topRatedMovies.append(contentsOf: movies)
  }
  
  @MainActor
  private func fetchUpcomingMovies() async throws {
    let upcomingMoviesResponse = try await service.fetchMovies(section: .upcoming, page: nextUpcomingPage)
    nextUpcomingPage = upcomingMoviesResponse.page + 1
    let movies = upcomingMoviesResponse
      .results
      .sorted(by: { $0.releaseDate > $1.releaseDate })
      upcomingMovies.append(contentsOf: movies)
  }
  
  func shouldLoadMoreData(_ movieId: Int, items: [Movie]) -> Bool {
    guard items.count > 10 else { return false }
    let targetItem = items[items.count - 5]
    return movieId == targetItem.id
  }
  
  func loadMoreData(for category: MovieSection) {
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
      case .trending:
        try? await fetchTrendingMovies()
      }
    }
  }
}
