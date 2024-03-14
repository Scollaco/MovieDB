@testable import SearchFeature
import XCTest

final class SearchViewModelTests: XCTestCase {
  @MainActor
  func testDebounceQuery() {
    let sut = SearchViewModel(service: MockService())
    let expectedOutput = "asd"
    sut.debouncedQuery = expectedOutput
    _ = sut.$debouncedQuery.sink { output in
      XCTAssertEqual(output, expectedOutput)
    }
  }
  
  func testResults() async {
    let sut = SearchViewModel(service: MockService())
    XCTAssertEqual(sut.results, [])
    await performSearch(sut: sut)
    XCTAssertEqual(sut.results, [.mock()])
  }
  
  func testSearchLabelIsVisible_zero_results() {
    let sut = SearchViewModel(service: MockService())
    XCTAssertTrue(sut.searchLabelIsVisible)
  }
  
  func testSearchLabelIsVisible_with_results() async {
    let sut = SearchViewModel(service: MockService())
    XCTAssertTrue(sut.searchLabelIsVisible)
    await performSearch(sut: sut)
    XCTAssertFalse(sut.searchLabelIsVisible)
  }
  
  private func performSearch(sut: SearchViewModel) async {
    let expectation = XCTestExpectation(description: "Perform search.")
    try? await sut.performSearch(query: "")
    expectation.fulfill()
    await fulfillment(of: [expectation], timeout: 5.0)
  }
}
