import Foundation
import MovieDBDependencies

public struct MovieEndpoint: Endpoint {
  public var path: String = "/3/movie/"
  public var additionalHeaders: [String : String]? = nil
  public var method: HTTPMethod {
    .get(
      [
        URLQueryItem(name: "page", value: "\(page)")
      ]
    )
  }
  let page: Int
  public init(category: MovieSection, page: Int = 1) {
    self.path.append(category.rawValue)
    self.page = page
  }
}

public struct TrendingEndpoint: Endpoint {
  public var path: String = "/3/trending/movie/"
  public var additionalHeaders: [String : String]? = nil
  public var method: HTTPMethod {
    .get(
      [
        URLQueryItem(name: "page", value: "\(page)"),
      ]
    )
  }
  let page: Int
  public init(
    page: Int = 1,
    timeWindow: TimeWindow = .week
  ) {
    self.page = page
    path.append(timeWindow.rawValue)
  }
}
