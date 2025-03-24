import Dependencies
import Networking

extension MoviesClient: DependencyKey {
  public static let liveValue: Self = .live(network: NetworkImpl())
}

extension MoviesClient {
  public static func live(network: NetworkImpl) -> Self {
    .init(
      fetchMovies: { section, page in
        try await network.requestTry(
          endpoint: MovieEndpoint(category: section, page: page),
          type: MovieResponse.self
        )
      },
      fetchTrendingMovies: { page, timeWindow in
        try await network.requestTry(
          endpoint: TrendingEndpoint(page: page, timeWindow: timeWindow),
          type: MovieResponse.self
        )
      }
    )
  }
}
