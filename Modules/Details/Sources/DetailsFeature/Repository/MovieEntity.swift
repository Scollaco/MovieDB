import Foundation
import SwiftData
import Storage

@Model
final class MovieEntity {
  @Attribute(.unique) public var id: Int
  public var backdropPath: String?
  public var posterPath: String?
  public var originalTitle: String
  public var overview: String
  public var releaseDate: String
  public var title: String
  
  init(
    id: Int,
    backdropPath: String? = nil,
    posterPath: String? = nil,
    originalTitle: String,
    overview: String,
    releaseDate: String,
    title: String
  ) {
    self.id = id
    self.backdropPath = backdropPath
    self.posterPath = posterPath
    self.originalTitle = originalTitle
    self.overview = overview
    self.releaseDate = releaseDate
    self.title = title
  }
}

extension MovieEntity: DomainModel {
  convenience init(_ movie: MovieDetails) {
    self.init(
      id: movie.id,
      backdropPath: movie.backdropPath,
      posterPath: movie.posterPath,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      releaseDate: movie.releaseDate,
      title: movie.title
    )
  }
  
  public var asDomainModel: MovieDetails {
    .init(
      backdropPath: backdropPath,
      posterPath: posterPath,
      genres: nil,
      id: id,
      originalTitle: originalTitle,
      title: title,
      overview: overview,
      releaseDate: releaseDate,
      tagline: nil,
      videos: .init(results: []),
      similar: .init(page: 1, results: []),
      recommendations: .init(page: 1, results: []), 
      watchProviders: .init(results: .init(US: nil)),
      reviews: nil,
      createdBy: []
    )
  }
}
