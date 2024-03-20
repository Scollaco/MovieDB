import Foundation
import Dependencies

public protocol DetailsService {
  func fetchMovieDetails(id: Int) async throws -> MovieDetails
}

public final class MovieDetailsService: DetailsService {
  private let dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func fetchMovieDetails(id: Int) async throws -> MovieDetails {
    let result = await dependencies.network.request(
      endpoint: DetailsEndpoint(id: id, path: "/3/movie/"),
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

fileprivate struct DetailsEndpoint: Endpoint {
  var path: String
  var additionalHeaders: [String: String]? = nil
  var method: HTTPMethod {
    .get(
      [
        URLQueryItem(
          name: "append_to_response",
          value: "videos,similar,recommendations,watch/providers,reviews"
        )
      ]
    )
  }
  init(id: Int, path: String) {
    self.path = path
    self.path.append("\(id)")
  }
}
