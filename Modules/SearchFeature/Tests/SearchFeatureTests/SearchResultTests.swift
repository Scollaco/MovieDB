@testable import SearchFeature
import XCTest

final class SearchResultsTests: XCTestCase {
  func testPlaceholderImage_Movie() {
    let sut = SearchResult(id: 1, mediaTypeString: "movie")
    XCTAssertEqual(sut.placeholderImage, "movieclapper")
  }
  
  func testPlaceholderImage_Tv() {
    let sut = SearchResult(id: 1, mediaTypeString: "tv")
    XCTAssertEqual(sut.placeholderImage, "tv")
  }
  
  func testPlaceholderImageUrl() {
    let sut = SearchResult(id: 1, posterPath: "my_result")
    XCTAssertEqual(sut.imageUrl, "https://image.tmdb.org/t/p/w500/my_result")
  }
  
  func testMediaType_Movie() {
    let sut = SearchResult(id: 1, mediaTypeString: "movie")
    XCTAssertEqual(sut.mediaType, .movie)
  }
  
  func testMediaType_Tv() {
    let sut = SearchResult(id: 1, mediaTypeString: "tv")
    XCTAssertEqual(sut.mediaType, .tv)
  }
  
  func testMediaType_Unknown() {
    let sut = SearchResult(id: 1, mediaTypeString: "people")
    XCTAssertEqual(sut.mediaType, .unknown)
  }
}
