import Foundation
import MovieDBDependencies

protocol Service {
  func search(query: String, page: Int) async throws -> SearchResultResponse
}

final class SearchService: Service {
  private let dependencies: MovieDBDependencies
  init(dependencies: MovieDBDependencies) {
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
