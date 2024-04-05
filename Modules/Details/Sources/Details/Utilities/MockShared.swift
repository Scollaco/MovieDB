import Foundation

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
    key: String = "youtube_id",
    name: String = "Video name"
  ) -> Video {
    Video(
      id: id,
      type: type,
      official: official,
      key: key,
      name: name
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

