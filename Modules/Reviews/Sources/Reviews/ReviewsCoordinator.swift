import ComposableArchitecture
import MovieDBDependencies
import SwiftUI

public final class ReviewsCoordinator: ObservableObject {
  @Published public var path = NavigationPath()
  let dependencies: MovieDBDependencies
  // MARK: - Navigation
  
  public init(dependencies: MovieDBDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - View providers
  @ViewBuilder
  public func get(page: Page) -> some View {
    switch page {
    case .home(let mediaType, let id):
      ReviewsMainView(
        store: Store(initialState: ReviewsFeature.State(id: id, mediaType: mediaType)) {
          ReviewsFeature()
        }
      )
    }
  }
}

public enum Page: Identifiable, Hashable {
  case home(mediaType: String, id: Int)
  
  public var id: String {
    ID(describing: self)
  }
}
