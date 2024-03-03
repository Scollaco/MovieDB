import Foundation

protocol Listable {
  var name: String { get }
  var imageUrl: String { get }
  var id: Int { get }
}

public struct SeriesResponse: Decodable {
  let page: Int
  let results: [Series]
}

public struct Series: Decodable, Hashable, Listable {
  let adult: Bool
  let backdropPath: String?
  public let id: Int
  let genreIds: [Int]
  let originalLanguage: String
  let originalName: String
  let overview: String
  let popularity: Double
  let posterPath: String?
  let firstAirDate: String
  let name: String
  let voteAverage: Double
  let voteCount: Int
}

extension Series {
  var imageUrl: String {
    guard let path = posterPath else { return . init() }
    return "https://image.tmdb.org/t/p/w500/\(path)"
  }
}
