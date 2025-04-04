import Foundation
import SwiftData
import Storage

@Model
final class MediaEntity {
  @Attribute(.unique) public var id: Int
  public var backdropPath: String?
  public var posterPath: String?
  public var originalTitle: String
  public var overview: String
  public var mediaType: String
  public var title: String
  
  init(
    id: Int,
    backdropPath: String? = nil,
    posterPath: String? = nil,
    originalTitle: String,
    overview: String,
    mediaType: String = "",
    title: String
  ) {
    self.id = id
    self.backdropPath = backdropPath
    self.posterPath = posterPath
    self.originalTitle = originalTitle
    self.overview = overview
    self.mediaType = mediaType
    self.title = title
  }
}

extension MediaEntity: DomainModel {
  convenience init(_ media: MediaProjection) {
    self.init(
      id: media.id,
      backdropPath: media.backdropPath,
      posterPath: media.posterPath,
      originalTitle: media.originalTitle,
      overview: media.overview,
      mediaType: media.mediaType,
      title: media.title
    )
  }
  
  public var asDomainModel: MediaProjection {
    .init(
      id: id,
      backdropPath: backdropPath,
      posterPath: posterPath,
      originalTitle: originalTitle,
      overview: overview,
      mediaType: mediaType,
      title: title
    )
  }
}
