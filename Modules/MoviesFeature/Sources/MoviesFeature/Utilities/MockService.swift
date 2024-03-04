import Foundation

final class MockService: Service {
  func fetchMovies(
    section: MoviesFeature.MovieSection,
    page: Int
  ) async throws -> MoviesFeature.MovieResponse {
    MovieResponse(
      page: 1,
      results: [.mock()]
    )
  }
}

