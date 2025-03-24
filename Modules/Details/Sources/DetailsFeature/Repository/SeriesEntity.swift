import Foundation
import SwiftData
import Storage

@Model
final class SeriesEntity {
  @Attribute(.unique) public var id: Int
  public var backdropPath: String?
  public var posterPath: String?
  public var originalName: String
  public var overview: String
  public var name: String
  
  init(
    id: Int,
    backdropPath: String? = nil,
    posterPath: String? = nil,
    originalName: String,
    overview: String,
    name: String
  ) {
    self.id = id
    self.backdropPath = backdropPath
    self.posterPath = posterPath
    self.originalName = originalName
    self.overview = overview
    self.name = name
  }
}

extension SeriesEntity: DomainModel {
  convenience init(_ series: SeriesDetails) {
    self.init(
      id: series.id,
      backdropPath: series.backdropPath,
      posterPath: series.posterPath,
      originalName: series.originalName,
      overview: series.overview,
      name: series.name
    )
  }
  
  public var asDomainModel: SeriesDetails {
    .init(
      backdropPath: backdropPath,
      posterPath: posterPath,
      createdBy: nil,
      firstAirDate: "",
      lastAirDate: "",
      genres: nil,
      id: id,
      numberOfEpisodes: 0,
      numberOfSeasons: 0,
      originalName: originalName,
      overview: overview,
      seasons: [],
      name: name,
      releaseDate: nil,
      tagline: nil,
      videos: nil,
      recommendations: nil,
      similar: nil,
      watchProviders: nil,
      reviews: nil
    )
  }
}
