import Foundation

public struct SearchResultResponse: Decodable {
  let page: Int
  let results: [SearchResult]
}

public enum MediaType: String {
  case movie
  case tv
  case person
  case unknown
  
  var placeholder: String {
    switch self {
    case .movie:
      return "movieclapper"
    case .tv:
      return "tv"
    case .person:
      return "person"
    default:
      return "questionmark"
    }
  }
}

public struct SearchResult {
  var backDropPath: String?
  var id: Int
  var title: String?
  var name: String?
  var posterPath: String?
  var profilePath: String?
  var mediaTypeString: String?
  var popularity: Double?
  var voteAverage: Double?
  
  enum CodingKeys: String, CodingKey {
    case backDropPath
    case id
    case title
    case name
    case posterPath
    case profilePath
    case mediaType
    case popularity
    case voteAverage
  }
  
  var mediaType: MediaType {
    guard let type = mediaTypeString else {
      assertionFailure("Unknown type")
      return .unknown
    }
    return MediaType(rawValue: type) ?? .unknown
  }
  
  var imageUrl: String {
    let path = posterPath ?? backDropPath ?? profilePath
    guard let path = path else { return . init() }
    return path.url
  }
}

extension SearchResult: Decodable, Hashable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.backDropPath = try container.decodeIfPresent(String.self, forKey: .backDropPath)
    self.id = try container.decode(Int.self, forKey: .id)
    self.mediaTypeString = try container.decodeIfPresent(String.self, forKey: .mediaType)
    self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
    self.title = try container.decodeIfPresent(String.self, forKey: .title)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
    self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
  }
}
