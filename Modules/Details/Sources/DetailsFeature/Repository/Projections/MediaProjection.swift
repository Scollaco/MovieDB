import Foundation

public struct MediaProjection: Equatable, Sendable, Identifiable {
  public let id: Int
  public let backdropPath: String?
  public let posterPath: String?
  public let originalTitle: String
  public let overview: String
  public let title: String
  public let mediaType: String
  
  init(
    id: Int,
    backdropPath: String? = nil,
    posterPath: String? = nil,
    originalTitle: String = "",
    overview: String = "",
    mediaType: String = "",
    title: String = ""
  ) {
    self.id = id
    self.backdropPath = backdropPath
    self.posterPath = posterPath
    self.originalTitle = originalTitle
    self.overview = overview
    self.mediaType = mediaType
    self.title = title
  }
  
  public var imageUrl: String {
    guard let path = (posterPath ?? backdropPath) else { return . init() }
    return path.url
  }
}
