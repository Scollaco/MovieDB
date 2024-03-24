import Foundation

public struct ReviewsResponse: Decodable {
  public let page: Int
  public let results: [Review]?
}

public struct Review: Decodable {
  public struct AuthorDetails: Decodable {
    public let name: String?
    public let username: String?
    public let avatarPath: String?
    public let rating: Int?
    
    public var imageUrl: String {
      guard let path = avatarPath else { return . init() }
      return "https://image.tmdb.org/t/p/w500/\(path)"
    }
  }
  public let id: String
  public let author: String?
  public let authorDetails: AuthorDetails?
  public let content: String?
  public let createdAt: String
  public let updatedAt: String?
}
