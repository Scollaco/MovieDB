import DependenciesMacros
import Foundation

@DependencyClient
public struct MovieRepository: Sendable {
  /// Get a movie by id
  var getMovie: @Sendable (Int) async throws -> MovieDetails?
  /// Get a list of movies using a predicate
  var getMovies: @Sendable () async throws -> [MovieDetails]
  /// Creates a movie on the persistance layer.
  var create: @Sendable (MovieDetails) async throws -> Void
  /// Deletes a movie from the persistance layer.
  var delete: @Sendable (Int) async throws -> Void
}
