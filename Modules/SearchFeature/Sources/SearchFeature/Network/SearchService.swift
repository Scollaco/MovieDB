import Foundation
import Dependencies

protocol Service {
  func search(query: String, page: Int) async throws -> SearchResultResponse
}

final class SearchService: Service {
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func search(query: String, page: Int = 1) async throws -> SearchResultResponse {
    let result = await dependencies.network.request(
      endpoint: SearchEndpoint(query: query, page: page),
      type: SearchResultResponse.self
    )
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw(error)
    }
  }
}

fileprivate struct SearchEndpoint: Endpoint {
  var path: String = "/3/search/multi"
  var additionalHeaders: [String: String]? = nil
  var method: HTTPMethod {
    .get([
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "query", value: "\(query)"),
      URLQueryItem(name: "include_adult", value: "false"),
    ])
  }
  let page: Int
  let query: String
  init(query: String, page: Int = 1) {
    self.page = page
    self.query = query
  }
}
