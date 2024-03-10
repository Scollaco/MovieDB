import Dependencies
import SwiftUI

final class MoviesCoordinator: ObservableObject {
  @Published var path = NavigationPath()
  @Published var page: Page = .home
  private let dependencies: Dependencies
  private lazy var factory: MoviesViewFactory = {
    MoviesViewFactory(dependencies: dependencies)
  }()
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  func popToRoot() {
    path.removeLast(path.count)
  }
  
  func dismiss() {
    guard path.count > 0 else { return }
    path.removeLast()
  }
  
  func navigate(to destination: Page) {
    switch destination {
    case .home:
      path.append(Page.home)
    case .details(id: let id):
      path.append(Page.details(id: id))
    }
  }
  
  // MARK: - View providers
  @ViewBuilder
  func get(page: Page) -> some View {
    switch page {
    case .home:
      factory.makeMainView()
    case .details(id: let id):
      factory.makeMovieDetailsView(id: id)
    }
  }
}

enum Page: Identifiable, Hashable {
  case home
  case details(id: Int)
  
  var id: String {
    ID(describing: self)
  }
}
