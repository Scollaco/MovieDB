import Foundation

struct MovieResponse: Decodable {
  let page: Int
  let results: [Movie]
  
  init(page: Int, results: [Movie]) {
    self.page = page
    self.results = results
  }
}

public struct Movie: Decodable, Hashable {
  let adult: Bool
  let backdropPath: String?
  let id: Int
  let genreIds: [Int]
  let originalLanguage: String
  let originalTitle: String
  let overview: String
  let popularity: Double
  let posterPath: String?
  let releaseDate: String
  let title: String
  let voteAverage: Double
  let voteCount: Int
}
  
extension Movie {
  var imageUrl: String {
    guard let path = posterPath else { return . init() }
    return path.url
  }
  
  var formattedDate: String {
    String.formattedDate(releaseDate) ?? ""
  }
}
