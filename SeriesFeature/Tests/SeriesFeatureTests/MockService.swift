import Foundation
@testable import SeriesFeature

final class MockService: Service {
  func fetchSeriesDetails(id: Int) async throws -> SeriesFeature.SeriesDetails {
    SeriesDetails.mock()
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

extension SeriesDetails {
  static func mock(
    backdropPath: String? = "https://image.tmdb.org/t/p/w500/mSUnNIjJEkqkWxbklDjWCD2RUdy.jpg",
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
    videos: SeriesVideoResponse = .mock(),
    similar: SeriesResponse? = SeriesResponse(page: 1, results: [.mock()]),
    recommendations: SeriesResponse? = SeriesResponse(page: 1, results: [.mock()]),
    watchProviders: WatchProviderResponse = .mock()
  ) -> SeriesDetails {
    SeriesDetails(
      backdropPath: backdropPath,
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
      watchProviders: watchProviders
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

extension SeriesDetails.Genre {
  static func mock(
    id: Int = 1,
    name: String = "Drama"
  ) -> SeriesDetails.Genre {
    SeriesDetails.Genre(id: id, name: name)
  }
}

extension SeriesDetails.SeriesVideoResponse {
  static func mock() -> SeriesDetails.SeriesVideoResponse {
    SeriesDetails.SeriesVideoResponse(results: [.mock()])
  }
}

extension SeriesDetails.SeriesVideo {
  static func mock(
    id: String = "id",
    type: String = "Trailer",
    official: Bool = true,
    key: String = "youtube_id"
  ) -> SeriesDetails.SeriesVideo {
    SeriesDetails.SeriesVideo(
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
