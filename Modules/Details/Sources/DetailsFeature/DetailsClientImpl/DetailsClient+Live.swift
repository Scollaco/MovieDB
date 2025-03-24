import Dependencies
import Networking

extension DetailsClient: DependencyKey {
  public static let liveValue: Self = .live(network: NetworkImpl())
}

extension DetailsClient {
  public static func live(network: NetworkImpl) -> Self {
    .init(
      fetchMovieDetails: { id in
        try await network.requestTry(
          endpoint: DetailsEndpoint(id: id, path: "/3/movie/"),
          type: MovieDetails.self
        )
      },
      fetchSeriesDetails: { id in
        try await network.requestTry(
          endpoint: DetailsEndpoint(id: id, path: "/3/tv/"),
          type: SeriesDetails.self
        )
      }
    )
  }
}
