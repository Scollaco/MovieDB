import Foundation
import MovieDBDependencies

struct SeriesEndpoint: Endpoint {
  var path: String = "/3/tv/"
  var additionalHeaders: [String : String]? = nil
  var method: HTTPMethod {
    .get([URLQueryItem(name: "page", value: "\(page)")])
  }
  let page: Int
  init(category: SeriesCategory, page: Int = 1) {
    self.path.append(category.rawValue)
    self.page = page
  }
}

struct TrendingEndpoint: Endpoint {
  var path: String = "/3/trending/tv/"
  var additionalHeaders: [String : String]? = nil
  var method: HTTPMethod {
    .get(
      [
        URLQueryItem(name: "page", value: "\(page)"),
      ]
    )
  }
  let page: Int
  init(
    page: Int = 1,
    timeWindow: TimeWindow = .week
  ) {
    self.page = page
    path.append(timeWindow.rawValue)
  }
}
