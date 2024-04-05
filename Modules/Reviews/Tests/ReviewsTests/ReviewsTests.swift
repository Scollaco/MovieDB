import XCTest
@testable import Reviews

final class ReviewsTests: XCTestCase {
    func testShouldLoadMoreData_lessThanSixItemsInArray() throws {
      let sut = ReviewsMainViewModel(
        service: MockReviewsService(),
        mediaType: "movie", id: 1
      )
      sut.reviews = [.mock(), .mock(), .mock(), .mock(), .mock()]
    
      // Item index is not the last
      XCTAssertFalse(sut.shouldLoadMoreData("abcdefg"))
    }
}
