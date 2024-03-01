import Dependencies
import Foundation

public protocol Service {
  func fetchMovies(section: MovieSection, page: Int) async throws -> MovieResponse
  func fetchMovieDetails(id: Int) async throws -> MovieDetails
}

public enum MovieSection: String {
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
  
  func fetchMovieDetails(id: Int) async throws -> MovieDetails {
    let result = await dependencies.network.request(
      endpoint: MovieDetailsEndpoint(id: id),
      type: MovieDetails.self
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
  init(category: MovieSection, page: Int = 1) {
    self.path.append(category.rawValue)
    self.page = page
  }
}

fileprivate struct MovieDetailsEndpoint: Endpoint {
  var path: String = "/3/movie/"
  var additionalHeaders: [String : String]? = nil
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
  init(id: Int) {
    self.path.append("\(id)")
  }
}
