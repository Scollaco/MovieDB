import ComposableArchitecture
import MovieDBDependencies
import Details
import MoviesFeature
import SeriesFeature
import SwiftUI
import Routing

public final class WatchlistCoordinator: Coordinator, ObservableObject {
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
  
  func goToDetails(id: Int, type: MediaType) {}
  
  private lazy var mainView: some View = {
    WatchlistView(
      store: .init(
        initialState: WatchlistFeature.State()
      ) {
        WatchlistFeature()
      }
    )
  }()
  
  private lazy var moviesCoordinator: MoviesCoordinator = {
    MoviesCoordinator(dependencies: dependencies)
  }()

  private lazy var seriesCoordinator: SeriesCoordinator = {
    SeriesCoordinator(dependencies: dependencies)
  }()
  
  // MARK: - View providers
  @ViewBuilder
  public func get(page: Page) -> some View {
    switch page {
    case .home:
      mainView
    case .details(let id, let type):
      switch type {
      case .movie:
        moviesCoordinator.get(page: .details(id: id))
      case .tv:
        seriesCoordinator.get(page: .details(id: id))
      }
    }
  }
}

public enum Page: Identifiable, Hashable {
  case home
  case details(id: Int, type: MediaType)
  
  public var id: String {
    ID(describing: self)
  }
}
