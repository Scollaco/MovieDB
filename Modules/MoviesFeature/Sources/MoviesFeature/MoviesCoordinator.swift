import ComposableArchitecture
import MovieDBDependencies
import Details
import SwiftUI
import Routing

public final class MoviesCoordinator: Coordinator, ObservableObject {
  @Published public var path = NavigationPath()
  @Published var page: Page = .home
  let dependencies: MovieDBDependencies
  // MARK: - Navigation
  
  public init(dependencies: MovieDBDependencies) {
    self.dependencies = dependencies
  }
  
  public func popToRoot() {
    path.removeLast(path.count)
  }
  
  public func dismiss() {
    guard path.count > 0 else { return }
    path.removeLast()
  }
  
  func goToDetails(id: Int) {
    path.append(Page.details(id: id))
  }
  
  private lazy var mainView: some View = {
    MoviesMainView(
      store: Store(initialState: MoviesFeature.State()) {
        MoviesFeature()
      }
    )
  }()
  
//  private lazy var detailsCoordinator: DetailsCoordinator = {
//    DetailsCoordinator(dependencies: dependencies)
//  }()
  
  // MARK: - View providers
  @ViewBuilder
  public func get(page: Page) -> some View {
    switch page {
    case .home:
      mainView
    case .details(let id):
      mainView
      // detailsCoordinator.get(page: .movieDetails(id: id))
    }
  }
}

public enum Page: Identifiable, Hashable {
  case home
  case details(id: Int)
  
  public var id: String {
    ID(describing: self)
  }
}
