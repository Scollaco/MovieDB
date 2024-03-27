import Foundation

public struct SeriesDetails {
  public struct Creator: Decodable{
    public let id: Int
    public let name: String
  }
  
  public struct Season: Decodable, Listable {
    public let id: Int
    public let name: String
    public let posterPath: String?
    public let seasonNumber: Int
    
    public var imageUrl: String {
      guard let path = posterPath else { return . init() }
      return path.url
    }
  }
  
  public let backdropPath: String?
  public let posterPath: String?
  public let createdBy: [Creator]
  public let firstAirDate: String
  public let lastAirDate: String
  public let genres: [Genre]?
  public let id: Int
  public let numberOfEpisodes: Int
  public let numberOfSeasons: Int
  public let originalName: String
  public let overview: String
  public let seasons: [Season]
  public let name: String
  public let releaseDate: String?
  public let tagline: String?
  public let videos: VideoResponse?
  public let recommendations: SeriesResponse?
  public let similar: SeriesResponse?
  public let watchProviders: WatchProviderResponse?
  public let reviews: [Review]?

  public var trailerURL: URL? {
    guard let videos = videos?.results,
          !videos.isEmpty else {
      return nil
    }
    let trailer = videos.first(where: { $0.type == "Trailer" })
    return URL(string: "https://youtube.com/embed/\(trailer?.key ?? "")")
  }
  
  public var imageUrl: String {
    guard let path = posterPath else { return . init() }
    return path.url
  }
  
  enum CodingKeys: String, CodingKey{
    case backdropPath
    case posterPath
    case createdBy
    case firstAirDate
    case lastAirDate
    case genres
    case id
    case numberOfEpisodes
    case numberOfSeasons
    case originalName
    case seasons
    case overview
    case videos
    case name
    case releaseDate
    case tagline
    case recommendations
    case similar
    case reviews
    case watchProviders = "watch/providers"
  }
}

extension SeriesDetails: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
    self.createdBy = try container.decode([Creator].self, forKey: .createdBy)
    self.id = try container.decode(Int.self, forKey: .id)
    self.seasons = try container.decode([Season].self, forKey: .seasons)
    self.originalName = try container.decode(String.self, forKey: .originalName)
    self.name = try container.decode(String.self, forKey: .name)
    self.overview = try container.decode(String.self, forKey: .overview)
    self.firstAirDate = try container.decode(String.self, forKey: .firstAirDate)
    self.lastAirDate = try container.decode(String.self, forKey: .lastAirDate)
    self.numberOfEpisodes = try container.decode(Int.self, forKey: .numberOfEpisodes)
    self.numberOfSeasons = try container.decode(Int.self, forKey: .numberOfSeasons)
    self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
    self.videos = try container.decodeIfPresent(VideoResponse.self, forKey: .videos)
    self.similar = try container.decodeIfPresent(SeriesResponse.self, forKey: .similar)
    self.recommendations = try container.decodeIfPresent(SeriesResponse.self, forKey: .recommendations)
    self.watchProviders = try container.decodeIfPresent(WatchProviderResponse.self, forKey: .watchProviders)
    self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
    self.reviews = try container.decodeIfPresent(ReviewsResponse.self, forKey: .reviews)?.results
  }
}

public struct SeriesResponse: Decodable {
  public let page: Int
  public let results: [Details]
}
