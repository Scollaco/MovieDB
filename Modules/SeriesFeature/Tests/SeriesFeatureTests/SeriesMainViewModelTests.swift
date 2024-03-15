import Foundation
import XCTest
@testable import SeriesFeature

final class SeriesMainViewModelTests: XCTestCase {
  func testAiringTodayPagination() async throws {
    let sut = SeriesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextAiringTodayPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .airingToday)
    expectation.fulfill()
    await fulfillment(of: [expectation], timeout: 5.0)
    
    XCTAssertEqual(sut.nextAiringTodayPage, 2)
  }
  
  func testTopRatedPagination() async throws {
    let sut = SeriesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextTopRatedPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .topRated)
    expectation.fulfill()
    await fulfillment(of: [expectation], timeout: 5.0)
    XCTAssertEqual(sut.nextTopRatedPage, 2)
  }
  
  func testOnTheAirPagination() async throws {
    let sut = SeriesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextOnTheAirPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .onTheAir)
    expectation.fulfill()
    await  fulfillment(of: [expectation], timeout: 5.0)
    XCTAssertEqual(sut.nextOnTheAirPage, 2)
  }
  
  func testPopularPagination() async throws {
    let sut = SeriesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextPopularPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .popular)
    expectation.fulfill()
    await fulfillment(of: [expectation], timeout: 5.0)
    XCTAssertEqual(sut.nextPopularPage, 2)
  }
  
  func testShouldLoadMoreData_lessThanSixItemsInArray() {
    let sut = SeriesMainViewModel(service: MockService())
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
