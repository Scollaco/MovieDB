import Foundation

final class MockReviewsService {
  func fetchReviews(mediaType: String, id: Int, page: Int) async throws -> ReviewsResponse {
    return .init(
      page: 1,
      results: [.mock()]
    )
  }
}

public extension Review {
  static func mock(
    id: String = "abcdefg",
    author: String? = "Test author",
    authorDetails: AuthorDetails? = nil,
    content: String? = "Awesome movie!",
    createdAt: String = "2024-03-12",
    updatedAt: String? = nil
  ) -> Review {
        .init(
          id: id,
          author: author,
          authorDetails: authorDetails,
          content: content,
          createdAt: createdAt,
          updatedAt: updatedAt
        )
  }
}
