import Foundation

public struct MovieResponse: Decodable {
  let page: Int
  let results: [Movie]
}

public struct Movie: Decodable, Hashable {
  public let adult: Bool
  public let backdropPath: String?
  public let id: Int
  public let genreIds: [Int]
  public let originalLanguage: String
  public let originalTitle: String
  public let overview: String
  public let popularity: Double
  public let posterPath: String?
  public let releaseDate: String
  public let title: String
  public let voteAverage: Double
  public let voteCount: Int
}

extension Movie {
  public var imageUrl: String {
    guard let path = posterPath else { return . init() }
    return "https://image.tmdb.org/t/p/w500/\(path)"
  }
  
  public var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    guard let finalDate = formatter.date(from: releaseDate) else {
      return ""
    }
    formatter.dateStyle = .medium
    return formatter.string(from: finalDate)
  }
}
