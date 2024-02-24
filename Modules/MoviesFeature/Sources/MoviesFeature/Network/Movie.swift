import Foundation

struct MovieResponse: Decodable {
  let page: Int
  let results: [Movie]
}

struct Movie: Decodable {
  let adult: Bool
  let backdropPath: String
  let id: Int
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
