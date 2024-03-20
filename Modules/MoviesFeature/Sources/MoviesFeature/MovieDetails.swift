import Foundation

public struct MovieDetails {
  public let backdropPath: String?
  public let posterPath: String?
  public let genres: [Genre]?
  public let id: Int
  public let originalTitle: String
  public let title: String
  public let overview: String
  public let releaseDate: String
  public let tagline: String?
  public let videos: VideoResponse
  public let similar: MovieResponse
  public let recommendations: MovieResponse
  public let watchProviders: WatchProviderResponse
  public let reviews: [Review]?
  
  public var trailerURL: URL? {
    let trailer = videos.results.first(where: { $0.type == "Trailer" })
    return URL(string: "https://youtube.com/embed/\(trailer?.key ?? "")")
  }
  
  enum CodingKeys: String, CodingKey{
    case backdropPath, posterPath
    case originalTitle
    case releaseDate
    case watchProviders = "watch/providers"
    case genres, id, overview, title, tagline, videos, similar, recommendations, reviews
  }
  
  public var imageUrl: String {
    guard let path = posterPath else { return . init() }
    return "https://image.tmdb.org/t/p/w500/\(path)"
  }
}

extension MovieDetails: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
    self.id = try container.decode(Int.self, forKey: .id)
    self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
    self.title = try container.decode(String.self, forKey: .title)
    self.overview = try container.decode(String.self, forKey: .overview)
    self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
    self.videos = try container.decode(VideoResponse.self, forKey: .videos)
    self.similar = try container.decode(MovieResponse.self, forKey: .similar)
    self.recommendations = try container.decode(MovieResponse.self, forKey: .recommendations)
    self.watchProviders = try container.decode(WatchProviderResponse.self, forKey: .watchProviders)
    self.reviews = try container.decodeIfPresent(ReviewsResponse.self, forKey: .reviews)?.results
  }
}

public protocol Listable {
  var name: String { get }
  var imageUrl: String { get }
  var id: Int { get }
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

public struct ReviewsResponse: Decodable {
  public let page: Int
  public let results: [Review]?
}

public struct Review: Decodable {
  public struct AuthorDetails: Decodable {
    public let name: String?
    public let username: String?
    public let avatarPath: String?
    public let rating: Int?
  }
  public let author: String?
  public let authorDetails: AuthorDetails?
  public let content: String?
  public let createdAt: String?
  public let updatedAt: String?
}
