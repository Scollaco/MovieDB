import DependenciesMacros
import Foundation

@DependencyClient
public struct SeriesRepository: Sendable {
  /// Get a series  by id
  public var getSeries: @Sendable (Int) async throws -> SeriesDetails?
  /// Get a list of movies using a predicate
  public var getAllSeries: @Sendable () async throws -> [SeriesDetails]
  /// Creates a movie on the persistance layer.
  public var create: @Sendable (SeriesDetails) async throws -> Void
  /// Deletes a movie from the persistance layer.
  public var delete: @Sendable (Int) async throws -> Void
}
