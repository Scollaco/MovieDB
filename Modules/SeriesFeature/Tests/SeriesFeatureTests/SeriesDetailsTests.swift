@testable import SeriesFeature
import XCTest

final class SeriesDetailsTests: XCTestCase {
  func testSeason_imageUrl() {
    let sut = SeriesDetails.Season(
      id: 1,
      name: "season 1",
      posterPath: "season_path",
      seasonNumber: 1
    )
    XCTAssertEqual(sut.imageUrl, "https://image.tmdb.org/t/p/w500/season_path")
  }
  
  func testTrailerUrl() {
    let video = Video.mock(type: "Trailer", key: "trailer_key")
    let sut = SeriesDetails.mock(videos: .mock(videos: [video]))
    XCTAssertEqual(sut.trailerURL?.absoluteString, "https://youtube.com/embed/trailer_key")
  }
  
  func test_watchProviderLogo() {
    let sut = WatchProvider.mock(logoPath: "logo_path")
    XCTAssertEqual(sut.logoUrl, "https://image.tmdb.org/t/p/w500/logo_path")
  }
}
