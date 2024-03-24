import Dependencies
import Reviews
import Routing
import SwiftUI

public final class SeriesCoordinator: Coordinator, ObservableObject {
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
  
  func goToReviews(id: Int) {
    path.append(Page.reviews(id: id))
  }
  
  private lazy var mainView: some View = {
    let service = SeriesService(dependencies: dependencies)
    let viewModel = SeriesMainViewModel(service: service)
    return SeriesMainView(
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
      let service = SeriesDetailsService(dependencies: dependencies)
      let viewModel = SeriesDetailsViewModel(
        id: id,
        service: service,
        repository: SeriesRepository()
      )
      SeriesDetailsView(
        viewModel: viewModel,
        dependencies: dependencies,
        coordinator: self
      )
    case .reviews(id: let id):
      let reviewsCoordinator = ReviewsCoordinator(dependencies: dependencies)
      reviewsCoordinator.get(page: .home(mediaType: "tv", id: id))
    }
  }
}

public enum Page: Identifiable, Hashable {
  case home
  case details(id: Int)
  case reviews(id: Int)
  
  public var id: String {
    ID(describing: self)
  }
}
