import Foundation

extension SeriesDetails {
  static func mock(
    backdropPath: String? = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
    posterPath: String? = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
    createdBy: [Creator] = [.mock()],
    firstAirDate: String = "2021-11-21",
    lastAirDate: String = "2023-11-21",
    genres: [Genre] = [.mock()],
    id: Int = 1,
    numberOfEpisodes: Int = 30,
    numberOfSeasons: Int = 11,
    originalName: String = "Original",
    title: String = "Other title",
    overview: String = "",
    seasons: [Season] = [.mock()],
    name: String = "Series name",
    releaseDate: String = "2024-01-31",
    tagline: String? = nil,
    videos: VideoResponse = .mock(),
    similar: SeriesResponse? = nil,
    recommendations: SeriesResponse? = nil,
    watchProviders: WatchProviderResponse = .mock(results: .mock()),
    reviews: [Review]? = []
  ) -> SeriesDetails {
    SeriesDetails(
      backdropPath: backdropPath,
      posterPath: posterPath,
      createdBy: createdBy,
      firstAirDate: firstAirDate,
      lastAirDate: lastAirDate,
      genres: genres,
      id: id,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      originalName: originalName,
      overview: overview,
      seasons: seasons,
      name: name,
      releaseDate: releaseDate,
      tagline: tagline,
      videos: videos,
      recommendations: recommendations,
      similar: similar,
      watchProviders: watchProviders,
      reviews: reviews
    )
  }
}

extension SeriesDetails.Season {
  static func mock(
    id: Int = 1,
    name: String = "Season 1",
    posterPath: String = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
    seasonNumber: Int = 10
  ) -> SeriesDetails.Season {
    SeriesDetails.Season(
      id: id,
      name: name,
      posterPath: posterPath,
      seasonNumber: seasonNumber
    )
  }
}

extension SeriesDetails.Creator {
  static func mock(id: Int = 1, name: String = "Creator") -> SeriesDetails.Creator {
    SeriesDetails.Creator(id: id, name: name)
  }
}
