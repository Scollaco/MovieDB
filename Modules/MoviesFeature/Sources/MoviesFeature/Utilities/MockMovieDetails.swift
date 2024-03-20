import Foundation
import Core

extension MovieDetails {
  static func mock(
    backdropPath: String? = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
    posterPath: String = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
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
    reviews: [Review]? = []
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

extension Genre {
  static func mock(
    id: Int = 1,
    name: String = "Drama"
  ) -> Genre {
    Genre(id: id, name: name)
  }
}

extension VideoResponse {
  static func mock() -> VideoResponse {
    VideoResponse(results: [.mock()])
  }
}

extension Video {
  static func mock(
    id: String = "id",
    type: String = "Trailer",
    official: Bool = true,
    key: String = "youtube_id"
  ) -> Video {
    Video(
      id: id,
      type: type,
      official: official,
      key: key
    )
  }
}

extension WatchProviderResponse {
  static func mock(results: WatchProvidersRegion = .mock()) -> WatchProviderResponse {
    WatchProviderResponse(results: results)
  }
}

extension WatchProvidersRegion {
  static func mock(options: WatchOptions? = .mock()) -> WatchProvidersRegion {
    WatchProvidersRegion(US: options)
  }
}

extension WatchOptions {
  static func mock(
    flatrate: [WatchProvider] = [.mock()],
    rent: [WatchProvider] = [.mock()],
    buy: [WatchProvider] = [.mock()]
  ) -> WatchOptions {
    WatchOptions(
      flatrate: flatrate,
      rent: rent,
      buy: buy
    )
  }
}

extension WatchProvider {
  static func mock(
    logoPath: String = "logo_path",
    providerId: Int = 1,
    providerName: String = "Netflix",
    displayPriority: Int = 1
  ) -> WatchProvider {
    WatchProvider(
      logoPath: logoPath,
      providerId: providerId,
      providerName: providerName,
      displayPriority: displayPriority
    )
  }
}

