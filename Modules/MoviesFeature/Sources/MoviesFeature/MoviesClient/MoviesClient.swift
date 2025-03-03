import DependenciesMacros
import Foundation

@DependencyClient
public struct MoviesClient: Sendable {
  var fetchMovies: @Sendable (MovieSection, Int) async throws -> MovieResponse
  var fetchTrendingMovies: @Sendable (Int, TimeWindow) async throws -> MovieResponse
}

public enum MovieSection: String {
  case nowPlaying = "now_playing"
  case popular
  case topRated = "top_rated"
  case upcoming
  case trending
}

public enum TimeWindow: String {
  case day
  case week
}
