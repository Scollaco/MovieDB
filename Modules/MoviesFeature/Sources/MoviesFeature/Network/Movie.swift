import Foundation

public struct MovieResponse: Decodable {
  let page: Int
  let results: [Movie]
}

public struct Movie: Decodable, Identifiable {
  let adult: Bool
  let backdropPath: String
  public let id: Int
  let genreIds: [Int]
  let originalLanguage: String
  let originalTitle: String
  let overview: String
  let popularity: Double
  let posterPath: String
  let releaseDate: String
  let title: String
  let voteAverage: Double
  let voteCount: Int
}

extension Movie {
  var imageUrl: String {
    "https://image.tmdb.org/t/p/w500/\(posterPath)"
  }
  
  var formattedDate: String {
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
