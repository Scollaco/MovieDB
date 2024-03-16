import Dependencies
import SwiftUI
import Routing

public final class MoviesCoordinator: Coordinator, ObservableObject {
  @Published public var path = NavigationPath()
  @Published var page: Page = .home
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
  
  func goToDetails(id: Int) {
    path.append(Page.details(id: id))
  }
  
  private lazy var mainView: some View = {
    let service = MoviesService(dependencies: dependencies)
    let viewModel = MoviesMainViewModel(service: service)
    return MoviesMainView(
      viewModel: viewModel,
      dependencies: dependencies,
      coordinator: self
    )
  }()
  
  // MARK: - View providers
  @ViewBuilder
  public func get(page: Page) -> some View {
    switch page {
    case .home:
      mainView
    case .details(let id):
      let service = MovieDetailsService(dependencies: dependencies)
      let viewModel = MovieDetailsViewModel(
        id: id,
        service: service,
        repository: MovieRepository()
      )
      MovieDetailsView(
        viewModel: viewModel,
        dependencies: dependencies,
        coordinator: self
      )
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
