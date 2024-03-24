import Foundation

final class MockService: Service {
  func fetchSeriesDetails(id: Int) async throws -> SeriesDetails {
    SeriesDetails.mock()
  }
  func fetchMovieDetails(id: Int) async throws -> MovieDetails {
    MovieDetails.mock()
  }
}

