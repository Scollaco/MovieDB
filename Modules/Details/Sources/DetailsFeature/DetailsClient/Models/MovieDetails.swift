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
  public let createdBy: [Creator]?

  public var trailerURL: URL? {
    let trailer = videos.results.first(where: { $0.type == "Trailer" })
    return trailer?.videoUrl
  }
  
  public var imageUrl: String {
    guard let path = posterPath else { return . init() }
    return path.url
  }
  
  var shareUrl: URL? {
      URL(string: "https://www.themoviedb.org/movie/\(id)")
  }
  
  enum CodingKeys: String, CodingKey{
    case backdropPath
    case posterPath
    case originalTitle
    case releaseDate
    case watchProviders = "watch/providers"
    case genres, id, overview, title, tagline, videos, similar, recommendations, reviews, createdBy
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
    self.createdBy = try container.decodeIfPresent([Creator].self, forKey: .createdBy)
//    
//
//    self.seasons = try container.decode([Season].self, forKey: .seasons)
//    self.firstAirDate = try container.decode(String.self, forKey: .firstAirDate)
//    self.lastAirDate = try container.decode(String.self, forKey: .lastAirDate)
//    self.numberOfEpisodes = try container.decode(Int.self, forKey: .numberOfEpisodes)
//    self.numberOfSeasons = try container.decode(Int.self, forKey: .numberOfSeasons)
  }
}

public struct MovieResponse: Decodable {
  public let page: Int
  public let results: [Details]
  public init(page: Int, results: [Details]) {
    self.page = page
    self.results = results
  }
}
