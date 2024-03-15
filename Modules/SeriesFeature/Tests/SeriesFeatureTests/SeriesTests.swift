@testable import SeriesFeature
import XCTest

final class SeriesTests: XCTestCase {
  func testImageUrl() {
    let sut = Series(
      adult: false,
      backdropPath: nil,
      id: 1,
      genreIds: [],
      originalLanguage: "",
      originalName: "",
      overview: "",
      popularity: 0,
      posterPath: "my_path",
      firstAirDate: "",
      name: "",
      voteAverage: 0,
      voteCount: 0
    )
    
    XCTAssertEqual(sut.imageUrl, "https://image.tmdb.org/t/p/w500/my_path")
  }
}
