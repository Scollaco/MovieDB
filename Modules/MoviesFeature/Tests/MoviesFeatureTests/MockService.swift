import Foundation
@testable import MoviesFeature

final class MockService: Service {
  func fetchMovies(
    category: MoviesFeature.Category,
    page: Int
  ) async throws -> MoviesFeature.MovieResponse {
    MovieResponse(
      page: 1,
      results: [.mock()]
    )
  }
}

extension Movie: Equatable {
  public static func == (lhs: Movie, rhs: Movie) -> Bool {
    lhs.id == rhs.id
  }
  
  static func mock(
    adult: Bool = true,
    backdropPath: String = "",
    id: Int = 1,
    genreIds: [Int] = [],
    originalLanguage: String = "en_US",
    originalTitle: String = "Test Movie",
    overview: String = "",
    popularity: Double = 5.0,
    posterPath: String = "",
    releaseDate: String = "2024-12-31",
    title: String = "Test Movie",
    voteAverage: Double = 8.0,
    voteCount: Int = 1000
  ) -> Movie {
    Movie(
      adult: adult,
      backdropPath: backdropPath,
      id: id,
      genreIds: genreIds,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      releaseDate: releaseDate,
      title: title,
      voteAverage: voteAverage,
      voteCount: voteCount
    )
  }
}
