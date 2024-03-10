import Foundation
import Dependencies

public protocol DetailsService {
  func fetchSeriesDetails(id: Int) async throws -> SeriesDetails
}

public final class SeriesDetailsService: DetailsService {
  private let dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func fetchSeriesDetails(id: Int) async throws -> SeriesDetails {
    let result = await dependencies.network.request(
      endpoint: DetailsEndpoint(id: id, path: "/3/tv/"),
      type: SeriesDetails.self
    )
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw(error)
    }
  }
}

fileprivate struct DetailsEndpoint: Endpoint {
  var path: String
  var additionalHeaders: [String: String]? = nil
  var method: HTTPMethod {
    .get(
      [
        URLQueryItem(
          name: "append_to_response",
          value: "videos,similar,recommendations,watch/providers"
        )
      ]
    )
  }
  init(id: Int, path: String) {
    self.path = path
    self.path.append("\(id)")
  }
}
