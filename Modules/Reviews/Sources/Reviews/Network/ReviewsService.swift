import ComposableArchitecture
import MovieDBDependencies
import Networking
import Foundation
import XCTestDynamicOverlay

private let network = NetworkImpl()

extension DependencyValues {
  var apiClient: ReviewsService {
    get { self[ReviewsService.self] }
    set { self[ReviewsService.self] = newValue }
  }
}

struct ReviewsService: Sendable {
  var currentPage = 1
  
  var fetchReviews: @Sendable ((mediaType: String, id: Int, page: Int)) async -> Result<ReviewsResponse, Error>
}

extension ReviewsService: TestDependencyKey {
  static var testValue = Self(
    fetchReviews: { _ in
        .success(ReviewsResponse(page: 1, results: []))
    }
  )
}

extension ReviewsService: DependencyKey {
  static let liveValue = Self(
    fetchReviews: { (mediaType, id, page) in
      let result = await network.request(
        endpoint: ReviewsEndpoint(mediaType: mediaType, id: id, page: page),
        type: ReviewsResponse.self
      )
      switch result {
      case .success(let response):
        return .success(response)
      case .failure(let error):
        return .failure(error)
      }
    }
  )
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
