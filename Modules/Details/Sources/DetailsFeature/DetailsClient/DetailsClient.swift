import DependenciesMacros
import Foundation

@DependencyClient
public struct DetailsClient: Sendable {
  var fetchMovieDetails: @Sendable (Int) async throws -> MovieDetails
  var fetchSeriesDetails: @Sendable (Int) async throws -> SeriesDetails
}
