import Foundation
import XCTest
@testable import MoviesFeature

final class MoviesMainViewModelTests: XCTestCase {
  func testNowPlayingPagination() async throws {
    let sut = MoviesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextNowPlayingPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .nowPlaying)
    expectation.fulfill()
    await fulfillment(of: [expectation], timeout: 5.0)
    
    XCTAssertEqual(sut.nextNowPlayingPage, 2)
  }
  
  func testTopRatedPagination() async throws {
    let sut = MoviesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextTopRatedPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .topRated)
    expectation.fulfill()
    await fulfillment(of: [expectation], timeout: 5.0)
    
    XCTAssertEqual(sut.nextTopRatedPage, 2)
  }
  
  func testUpcomingPagination() async throws {
    let sut = MoviesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextUpcomingPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .upcoming)
    expectation.fulfill()
    await fulfillment(of: [expectation], timeout: 5.0)
    
    XCTAssertEqual(sut.nextUpcomingPage, 2)
  }
  
  func testPopularPagination() async throws {
    let sut = MoviesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextPopularPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .popular)
    expectation.fulfill()
    await fulfillment(of: [expectation], timeout: 5.0)
    
    XCTAssertEqual(sut.nextPopularPage, 2)
  }
  
  func testShouldLoadMoreData_sixOrMoreItemsInArray() {
    let sut = MoviesMainViewModel(service: MockService())
    // Item index is < 1
    XCTAssertFalse(
      sut.shouldLoadMoreData(
        1,
        items: [.mock(id: 1), .mock(id: 2), .mock(id: 3), .mock(id: 4), .mock(id: 5), .mock(id: 6)])
    )
    
    // Item index is == 1
    XCTAssertTrue(
      sut.shouldLoadMoreData(
        2,
        items: [.mock(id: 1), .mock(id: 2), .mock(id: 3), .mock(id: 4), .mock(id: 5), .mock(id: 6)])
    )
  }
  
  func testShouldLoadMoreData_lessThanSixItemsInArray() {
    let sut = MoviesMainViewModel(service: MockService())
    // Item index is not the last
    XCTAssertFalse(
      sut.shouldLoadMoreData(
        3,
        items: [.mock(id: 1), .mock(id: 2), .mock(id: 3), .mock(id: 4)])
    )
    
    // Item index is the last
    XCTAssertTrue(
      sut.shouldLoadMoreData(
        4,
        items: [.mock(id: 1), .mock(id: 2), .mock(id: 3), .mock(id: 4)]
      )
    )
  }
}
