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
    await  fulfillment(of: [expectation], timeout: 5.0)
    
    XCTAssertEqual(sut.nextUpcomingPage, 2)
  }
  
  func testPopularPagination() async throws {
    let sut = MoviesMainViewModel(service: MockService())
    XCTAssertEqual(sut.nextPopularPage, 1)
    let expectation = XCTestExpectation(description: "Make API calls.")
    sut.loadMoreData(for: .popular)
    expectation.fulfill()
    await  fulfillment(of: [expectation], timeout: 5.0)
    
    XCTAssertEqual(sut.nextPopularPage, 2)
  }
}
