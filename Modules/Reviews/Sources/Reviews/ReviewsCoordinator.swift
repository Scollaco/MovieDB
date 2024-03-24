import Dependencies
import SwiftUI
import Routing

public final class ReviewsCoordinator: Coordinator, ObservableObject {
  @Published public var path = NavigationPath()
  let dependencies: Dependencies
  // MARK: - Navigation
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func popToRoot() {
    path.removeLast(path.count)
  }
  
  public func dismiss() {
    guard path.count > 0 else { return }
    path.removeLast()
  }
  
  // MARK: - View providers
  @ViewBuilder
  public func get(page: Page) -> some View {
    switch page {
    case .home(let mediaType, let id):
      let service = ReviewsService(dependencies: dependencies)
      let viewModel = ReviewsMainViewModel(service: service, mediaType: mediaType, id: id)
      ReviewsMainView(viewModel: viewModel)
    }
  }
}

public enum Page: Identifiable, Hashable {
  case home(mediaType: String, id: Int)
  
  public var id: String {
    ID(describing: self)
  }
}
