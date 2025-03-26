//import MovieDBDependencies
//import Foundation
//
//protocol Service {
//  func fetchSeries(category: Category, page: Int) async throws -> SeriesResponse
//  func fetchTrendingSeries(page: Int, timeWindow: TimeWindow) async throws -> SeriesResponse
//}
//
//enum SeriesCategory: String {
//  case trending
//  case airingToday = "airing_today"
//  case popular
//  case topRated = "top_rated"
//  case onTheAir = "on_the_air"
//}
//
//enum TimeWindow: String {
//  case day
//  case week
//}
//
//final class SeriesService: Service {
//  private let dependencies: MovieDBDependencies
//  init(dependencies: MovieDBDependencies) {
//    self.dependencies = dependencies
//  }
//  
//  func fetchSeries(
//    category: Category,
//    page: Int = 1
//  ) async throws -> SeriesResponse {
//    let result = await dependencies.network.request(
//      endpoint: SeriesEndpoint(category: category, page: page),
//      type: SeriesResponse.self
//    )
//    switch result {
//    case .success(let response):
//      return response
//    case .failure(let error):
//      throw(error)
//    }
//  }
//  
//  func fetchTrendingSeries(
//    page: Int = 1,
//    timeWindow: TimeWindow = .week
//  ) async throws -> SeriesResponse {
//    let result = await dependencies.network.request(
//      endpoint: TrendingEndpoint(page: page, timeWindow: timeWindow),
//      type: SeriesResponse.self
//    )
//    switch result {
//    case .success(let response):
//      return response
//    case .failure(let error):
//      throw(error)
//    }
//  }
//}
//
//fileprivate struct SeriesEndpoint: Endpoint {
//  var path: String = "/3/tv/"
//  var additionalHeaders: [String : String]? = nil
//  var method: HTTPMethod {
//    .get([URLQueryItem(name: "page", value: "\(page)")])
//  }
//  let page: Int
//  init(category: Category, page: Int = 1) {
//    self.path.append(category.rawValue)
//    self.page = page
//  }
//}
//
//fileprivate struct TrendingEndpoint: Endpoint {
//  var path: String = "/3/trending/tv/"
//  var additionalHeaders: [String : String]? = nil
//  var method: HTTPMethod {
//    .get(
//      [
//        URLQueryItem(name: "page", value: "\(page)"),
//      ]
//    )
//  }
//  let page: Int
//  init(
//    page: Int = 1,
//    timeWindow: TimeWindow = .week
//  ) {
//    self.page = page
//    path.append(timeWindow.rawValue)
//  }
//}
