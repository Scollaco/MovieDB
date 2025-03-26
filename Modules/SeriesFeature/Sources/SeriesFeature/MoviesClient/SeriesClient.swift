import DependenciesMacros
import Foundation

@DependencyClient
public struct SeriesClient: Sendable {
  var fetchSeries: @Sendable (SeriesCategory, Int) async throws -> SeriesResponse
  var fetchTrendingSeries: @Sendable (Int, TimeWindow) async throws -> SeriesResponse
}

public enum TimeWindow: String {
  case day
  case week
}

public enum SeriesCategory: String {
  case trending
  case airingToday = "airing_today"
  case popular
  case topRated = "top_rated"
  case onTheAir = "on_the_air"
}
