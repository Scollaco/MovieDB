import Dependencies
import Networking

extension SeriesClient: DependencyKey {
  public static let liveValue: Self = .live(network: NetworkImpl())
}

extension SeriesClient {
  public static func live(network: NetworkImpl) -> Self {
    .init(
      fetchSeries: { category, page in
        try await network.requestTry(
          endpoint: SeriesEndpoint(category: category, page: page),
          type: SeriesResponse.self
        )
      },
      fetchTrendingSeries: { page, timeWindow in
        try await network.requestTry(
          endpoint: TrendingEndpoint(page: page, timeWindow: timeWindow),
          type: SeriesResponse.self
        )
      }
    )
  }
}
