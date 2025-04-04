import DependenciesMacros
import Foundation

@DependencyClient
public struct DetailsClient: Sendable {
  public var fetchMovieDetails: @Sendable (Int) async throws -> MovieDetails
  public var fetchSeriesDetails: @Sendable (Int) async throws -> SeriesDetails
  public var fetchMedia: @Sendable(Int) async throws -> MediaProjection?
  public var fetchBookmarkedMedias: @Sendable() async throws -> [MediaProjection]
  public var saveMedia: @Sendable(MediaProjection) async throws -> Void
  public var deleteMedia: @Sendable(Int) async throws -> Void
}
