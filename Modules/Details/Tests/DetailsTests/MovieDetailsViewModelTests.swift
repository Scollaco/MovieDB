import XCTest
@testable import Details

final class MovieDetailsViewModelTests: XCTestCase {
    func testShareDetails_providersEmpty() throws {
      let sut = MovieDetailsViewModel(
        id: 1,
        service: MockMovieDetailsService(),
        repository: MovieRepository()
      )
    }
}
