import Foundation

final class MockMovieDetailsService: MovieDetailsServiceInterface {
  func fetchMovieDetails(id: Int) async throws -> MovieDetails {
    MovieDetails.mock()
  }
}

