import Foundation

public protocol Listable {
  var name: String { get }
  var imageUrl: String { get }
  var id: Int { get }
}

public struct Details: Decodable {
  public let backdropPath: String?
  public let id: Int
  public let posterPath: String?
  public let title: String?
  public let name: String?
  public let overview: String?
  
  public var imageUrl: String {
    guard let path = (posterPath ?? backdropPath) else { return . init() }
    return "https://image.tmdb.org/t/p/w500/\(path)"
  }
}

public struct VideoResponse: Decodable {
  public let results: [Video]
}

public struct Video: Decodable {
  public let id: String
  public let type: String
  public let official: Bool
  public let key: String
}

public struct Genre: Decodable {
  public let id: Int
  public let name: String
}

public struct WatchProviderResponse: Decodable {
  public let results: WatchProvidersRegion
}

public struct WatchProvidersRegion: Decodable {
  public let US: WatchOptions?
}

public struct WatchOptions: Decodable {
  public let flatrate: [WatchProvider]?
  public let rent: [WatchProvider]?
  public let buy: [WatchProvider]?
}

public struct WatchProvider: Decodable, Hashable {
  public let logoPath: String?
  public let providerId: Int
  public let providerName: String
  public let displayPriority: Int
  
  public var logoUrl: String {
    guard let path = logoPath else { return . init() }
    return "https://image.tmdb.org/t/p/w500/\(path)"
  }
}
