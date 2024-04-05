import Foundation

final class MockService: Service {
  func fetchTrendingSeries(page: Int, timeWindow: TimeWindow) async throws -> SeriesResponse {
    SeriesResponse.init(page: 1, results: [.mock()])
  }
  
  func fetchSeries(
    category: SeriesFeature.Category,
    page: Int
  ) async throws -> SeriesFeature.SeriesResponse {
    SeriesResponse.init(page: 1, results: [.mock()])
  }
}

extension Series {
  static func mock(
    adult: Bool = true,
    backdropPath: String = "",
    id: Int = 1,
    genreIds: [Int] = [],
    originalLanguage: String = "en_US",
    originalName: String = "Test Series",
    overview: String = "",
    popularity: Double = 5.0,
    posterPath: String = "",
    firstAirDate: String = "2024-12-31",
    name: String = "Test Series",
    voteAverage: Double = 8.0,
    voteCount: Int = 1000
  ) -> Series {
    Series(
      adult: adult,
      backdropPath: backdropPath,
      id: id,
      genreIds: genreIds,
      originalLanguage: originalLanguage,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      name: name,
      voteAverage: voteAverage,
      voteCount: voteCount
    )
  }
}
