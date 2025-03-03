import ComposableArchitecture
import XCTest
@testable import Reviews

@MainActor
final class ReviewsTests: XCTestCase {
  
  func testRequestReviews() async {
    let response = ReviewsResponse(page: 1, results: [.mock()])
    let store = TestStore(
      initialState: ReviewsFeature.State(
        id: 1,
        mediaType: "movie"
      )
    ) {
       ReviewsFeature()
     } withDependencies: {
       $0.apiClient.fetchReviews = { _ in
           .success(response)
       }
     }

    await store.send(.requestReviews(id: 1, mediaType: "movie"))
    
    await store.receive(\.reviewsResponse) {
      $0.reviews = response.results ?? []
      $0.currentPage = response.page
     }
   }

   func testGetFact_Failure() async {
     struct SomeError: Error {}
     let response = SomeError()
     
     let store = TestStore(
      initialState: ReviewsFeature.State(
        id: 1,
        mediaType: "movie"
      )
      ) {
        ReviewsFeature()
     } withDependencies: {
       $0.apiClient.fetchReviews = { _ in
           .failure(response)
       }
     }
     await store.send(.requestReviews(id: 1, mediaType: "movie"))
     
     XCTExpectFailure()
     await store.receive(\.reviewsResponseFailure) {
       $0.reviews = []
      }
   }
}
