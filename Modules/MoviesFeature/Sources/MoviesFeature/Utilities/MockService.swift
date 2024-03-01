import Foundation

final class MockService: Service {
  func fetchMovieDetails(id: Int) async throws -> MovieDetails {
    MovieDetails.mock()
  }
  
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

