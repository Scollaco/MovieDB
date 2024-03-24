import Dependencies
import Foundation

public protocol Service {
  func fetchReviews(mediaType: String, id: Int, page: Int) async throws -> ReviewsResponse
}

final class ReviewsService: Service {
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func fetchReviews(
    mediaType: String,
    id: Int,
    page: Int = 1
  ) async throws -> ReviewsResponse {
    let result = await dependencies.network.request(
      endpoint: ReviewsEndpoint(mediaType: mediaType, id: id, page: page),
      type: ReviewsResponse.self
    )
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw(error)
    }
  }
}

fileprivate struct ReviewsEndpoint: Endpoint {
  var additionalHeaders: [String : String]? = nil
  var path: String
  var method: HTTPMethod {
    .get(
      [
        URLQueryItem(name: "page", value: "\(page)")
      ]
    )
  }
  let page: Int
  init(mediaType: String, id: Int,  page: Int = 1) {
    self.path = mediaType == "movie" ? 
    "/3/movie/\(id)/reviews" :
    "/3/tv/\(id)/reviews"
    self.page = page
  }
}
