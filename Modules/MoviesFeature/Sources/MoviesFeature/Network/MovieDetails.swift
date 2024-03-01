import Foundation

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

public struct MovieDetails {
  public struct Genre: Decodable {
    public let id: Int
    public let name: String
  }
  
  public struct MovieVideoResponse: Decodable {
    public let results: [MovieVideo]
  }
  
  public struct MovieVideo: Decodable {
    public let id: String
    public let type: String
    public let official: Bool
    public let key: String
  }
  
  public let backdropPath: String?
  public let genres: [Genre]
  public let id: Int
  public let originalTitle: String
  public let title: String
  public let overview: String
  public let releaseDate: String
  public let tagline: String?
  public let videos: MovieVideoResponse
  public let similar: MovieResponse
  public let recommendations: MovieResponse
  public let watchProviders: WatchProviderResponse
  
  public var trailerURL: URL? {
    let trailer = videos.results.first(where: { $0.type == "Trailer" })
    return URL(string: "https://youtu.be/\(trailer?.key ?? "")")
  }
  
  enum CodingKeys: String, CodingKey{
    case backdropPath
    case originalTitle
    case releaseDate
    case watchProviders = "watch/providers"
    case genres, id, overview, title, tagline, videos, similar, recommendations
  }

}

extension MovieDetails: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    self.genres = try container.decode([Genre].self, forKey: .genres)
    self.id = try container.decode(Int.self, forKey: .id)
    self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
    self.title = try container.decode(String.self, forKey: .title)
    self.overview = try container.decode(String.self, forKey: .overview)
    self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
    self.videos = try container.decode(MovieVideoResponse.self, forKey: .videos)
    self.similar = try container.decode(MovieResponse.self, forKey: .similar)
    self.recommendations = try container.decode(MovieResponse.self, forKey: .recommendations)
    self.watchProviders = try container.decode(WatchProviderResponse.self, forKey: .watchProviders)
  }
}
