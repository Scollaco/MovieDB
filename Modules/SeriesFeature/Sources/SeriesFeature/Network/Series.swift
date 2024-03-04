import Foundation

public struct SeriesResponse: Decodable {
  public let page: Int
  public let results: [Series]
}

public struct Series: Decodable, Hashable {
  public let adult: Bool
  public let backdropPath: String?
  public let id: Int
  public let genreIds: [Int]
  public let originalLanguage: String
  public let originalName: String
  public let overview: String
  public let popularity: Double
  public let posterPath: String?
  public let firstAirDate: String
  public let name: String
  public let voteAverage: Double
  public let voteCount: Int
}

extension Series {
  public var imageUrl: String {
    guard let path = posterPath else { return . init() }
    return "https://image.tmdb.org/t/p/w500/\(path)"
  }
}
