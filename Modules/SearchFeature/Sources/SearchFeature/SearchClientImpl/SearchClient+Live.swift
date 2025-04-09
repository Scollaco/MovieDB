import Dependencies
import Networking

extension SearchClient: DependencyKey {
  public static let liveValue: Self = .live(network: NetworkImpl())
}

extension SearchClient {
  public static func live(network: NetworkImpl) -> Self {
    .init(
      search: { query, page in
        try await network.requestTry(
          endpoint: SearchEndpoint(
            query: query,
            page: page
          ),
          type: SearchResultResponse.self
        )
      }
    )
  }
}
