import Foundation

final class MockService: Service {
  func search(query: String, page: Int) async throws -> SearchResultResponse {
    SearchResultResponse(page: 1, results: [.mock()])
  }
}

extension SearchResult {
  static func mock(
    backDropPath: String = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
    id: Int = 1,
    title: String = "Result title",
    name: String = "Result name",
    posterPath: String = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
    mediaTypeString: String =  "movie",
    popularity: Double = 7.8,
    voteAverage: Double = 5.6
  ) -> SearchResult {
    SearchResult(
      backDropPath: backDropPath,
      id: id,
      title: title,
      name: name,
      posterPath: posterPath,
      mediaTypeString: mediaTypeString,
      popularity: popularity,
      voteAverage: voteAverage
    )
  }
}
