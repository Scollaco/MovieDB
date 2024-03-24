import Foundation
import Utilities

public final class ReviewsMainViewModel: ObservableObject {
  private let service: Service
  private let mediaType: String
  private let id: Int
  @Published var reviews: [Review] = []
  
  private(set) var nextPage = 1
  
  public init(service: Service, mediaType: String, id: Int) {
    self.service = service
    self.id = id
    self.mediaType = mediaType
  }
  
  func fetchReviews() {
    Task {
      do {
        try await fetchReviews(mediaType: mediaType, id: id)
      } catch {
        print(error)
      }
    }
  }
  
  @MainActor
  private func fetchReviews(mediaType: String, id: Int) async throws {
    let reviewsResponse = try await service.fetchReviews(
      mediaType: mediaType,
      id: id,
      page: nextPage
    )
    nextPage = reviewsResponse.page + 1
    let reviews = reviewsResponse
      .results?
      .compactMap { $0 }
      .filter {
        guard let content = $0.content, !content.isEmpty else { return false }
        return true
      }
      .sorted(by: { $0.createdAt > $1.createdAt})
    self.reviews.append(contentsOf: reviews ?? [])
  }
  
  func shouldLoadMoreData(_ id: String) -> Bool {
    // Fetch more data when list is approaching the end
    let targetItem = reviews.count >= 6 ? reviews[reviews.count - 5] : reviews.last
    return id == targetItem?.id
  }
  
  func loadMoreData() {
    Task { @MainActor in
      try? await fetchReviews(mediaType: mediaType, id: id)
      }
    }
}
