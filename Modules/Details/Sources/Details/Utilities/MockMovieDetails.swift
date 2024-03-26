import Foundation

extension MovieDetails {
  static func mock(
    backdropPath: String? = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
    posterPath: String? = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
    genres: [Genre] = [.mock()],
    id: Int = 1,
    originalTitle: String = "Original",
    title: String = "Other title",
    overview: String = "",
    releaseDate: String = "2024-01-31",
    tagline: String? = nil,
    videos: VideoResponse = .mock(),
    similar: MovieResponse = .init(page: 1, results: []),
    recommendations: MovieResponse = .init(page: 1, results: []),
    watchProviders: WatchProviderResponse = .mock(),
    reviews: [Review] = []
  ) -> MovieDetails {
    MovieDetails(
      backdropPath: backdropPath,
      posterPath: posterPath,
      genres: genres,
      id: id,
      originalTitle: originalTitle,
      title: title,
      overview: overview,
      releaseDate: releaseDate,
      tagline: tagline,
      videos: videos,
      similar: similar,
      recommendations: recommendations,
      watchProviders: watchProviders,
      reviews: reviews
    )
  }
}
