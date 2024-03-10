import Foundation

final class MockMovieDetailsService: DetailsService {
  func fetchMovieDetails(id: Int) async throws -> MovieDetails {
    MovieDetails.mock()
  }
}

