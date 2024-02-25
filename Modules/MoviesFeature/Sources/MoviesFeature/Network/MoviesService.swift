import Dependencies
import Foundation

public protocol Service {
  func fetchMovies(category: Category, page: Int) async throws -> MovieResponse
}

public enum Category: String {
  case nowPlaying = "now_playing"
  case popular
  case topRated = "top_rated"
  case upcoming
}

final class MoviesService: Service {
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func fetchMovies(
    category: Category,
    page: Int = 1
  ) async throws -> MovieResponse {
    let result = await dependencies.network.request(
      endpoint: MovieEndpoint(category: category, page: page),
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
    .get([URLQueryItem(name: "page", value: "\(page)")])
  }
  let page: Int
  init(category: Category, page: Int = 1) {
    self.path.append(category.rawValue)
    self.page = page
  }
}
