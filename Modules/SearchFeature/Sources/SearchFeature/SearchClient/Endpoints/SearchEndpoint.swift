import Foundation
import MovieDBDependencies

struct SearchEndpoint: Endpoint {
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
