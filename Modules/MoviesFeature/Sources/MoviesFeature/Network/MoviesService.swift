import Dependencies
import Foundation

protocol Service {
  func fetchMovies(section: MovieSection, page: Int) async throws -> MovieResponse
  func fetchTrendingMovies(page: Int, timeWindow: TimeWindow) async throws -> MovieResponse
}

enum MovieSection: String {
  case nowPlaying = "now_playing"
  case popular
  case topRated = "top_rated"
  case upcoming
  case trending
}

enum TimeWindow: String {
  case day
  case week
}

final class MoviesService: Service {
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func fetchMovies(
    section: MovieSection,
    page: Int = 1
  ) async throws -> MovieResponse {
    let result = await dependencies.network.request(
      endpoint: MovieEndpoint(category: section, page: page),
      type: MovieResponse.self
    )
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw(error)
    }
  }
  
  func fetchTrendingMovies(
    page: Int = 1,
    timeWindow: TimeWindow = .week
  ) async throws -> MovieResponse {
    let result = await dependencies.network.request(
      endpoint: TrendingEndpoint(page: page, timeWindow: timeWindow),
      type: MovieResponse.self
    )
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw(error)
    }
  }
}

fileprivate struct MovieEndpoint: Endpoint {
  var path: String = "/3/movie/"
  var additionalHeaders: [String : String]? = nil
  var method: HTTPMethod {
    .get(
      [
        URLQueryItem(name: "page", value: "\(page)")
      ]
    )
  }
  let page: Int
  init(category: MovieSection, page: Int = 1) {
    self.path.append(category.rawValue)
    self.page = page
  }
}

fileprivate struct TrendingEndpoint: Endpoint {
  var path: String = "/3/trending/movie/"
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
