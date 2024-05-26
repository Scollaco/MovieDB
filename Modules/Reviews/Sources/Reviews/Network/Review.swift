import Utilities

public struct ReviewsResponse: Decodable {
  public let page: Int
  public let results: [Review]?
}

public struct Review: Decodable, Equatable {
  public static func == (lhs: Review, rhs: Review) -> Bool {
    lhs.id == rhs.id
  }
  
  public struct AuthorDetails: Decodable {
    public let name: String?
    public let username: String?
    public let avatarPath: String?
    public let rating: Float?
    
    public var imageUrl: String {
      guard let path = avatarPath else { return . init() }
      return path.url
    }
  }
  public let id: String
  public let author: String?
  public let authorDetails: AuthorDetails?
  public let content: String?
  public let createdAt: String
  public let updatedAt: String?
}
