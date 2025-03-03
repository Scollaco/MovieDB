import Foundation
import Utilities
import ComposableArchitecture

@Reducer
struct ReviewsFeature {
  @Dependency(\.apiClient) var service
    
  @ObservableState
  struct State: Equatable {
    var reviews: [Review] = []
    var currentPage = 1
    var shouldLoadMoreData = false
    let id: Int
    let mediaType: String
  }
  
  enum Action {
    case requestReviews(id: Int, mediaType: String)
    case reviewsResponse(ReviewsResponse)
    case reviewsResponseFailure(Error)
    case cellDidAppear(id: Int)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .requestReviews(let id, let mediaType):
        return .run { [page = state.currentPage] send in
          let result = await service.fetchReviews(
            (mediaType: mediaType, id: id, page: page)
          )
          switch result {
          case .success(let response):
            await send(.reviewsResponse(response))
          case .failure(let error):
            await send(.reviewsResponseFailure(error))
          }
        }
      case .reviewsResponse(let response):
        let reviews = response.results?
            .compactMap { $0 }
            .filter {
              guard let content = $0.content, !content.isEmpty else { return false }
              return true
            }
            .sorted(by: { $0.createdAt > $1.createdAt})
        state.reviews.append(contentsOf: reviews ?? [])
        state.currentPage = response.page + 1
        return .none
      case .reviewsResponseFailure(let error):
        print(error)
        return .none
      case .cellDidAppear(let id):
        guard state.reviews.count > 10 else {
          return .none
        }
        let targetItem = state.reviews[state.reviews.count - 3]
        state.shouldLoadMoreData = "\(id)" == targetItem.id
        return .none
      }
    }
  }
}
