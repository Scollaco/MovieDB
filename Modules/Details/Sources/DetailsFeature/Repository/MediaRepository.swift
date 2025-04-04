import DependenciesMacros
import Foundation

@DependencyClient
public struct MediaRepository: Sendable {
  /// Get a movie by id
  var getMedia: @Sendable (Int) async throws -> MediaProjection?
  /// Get a list of movies using a predicate
  var getMedias: @Sendable () async throws -> [MediaProjection]
  /// Creates a movie on the persistance layer.
  var create: @Sendable (MediaProjection) async throws -> Void
  /// Deletes a movie from the persistance layer.
  var delete: @Sendable (Int) async throws -> Void
}
