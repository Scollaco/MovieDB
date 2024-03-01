import Foundation

extension Movie {
  static func mock(
    adult: Bool = true,
    backdropPath: String = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
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
