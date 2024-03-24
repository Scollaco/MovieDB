import Dependencies
import Reviews
import Routing
import SwiftUI

public final class DetailsCoordinator: Coordinator, ObservableObject {
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
  
  func goToSeriesDetails(id: Int) {
    path.append(Page.seriesDetails(id: id))
  }
 
  func goToMoviesDetails(id: Int) {
    path.append(Page.moviesDetails(id: id))
  }
  
  func goToReviews(id: Int, mediaType: String) {
    path.append(Page.reviews(id: id, type: mediaType))
  }

  // MARK: - View providers
  @ViewBuilder
  public func get(page: Page) -> some View {
    switch page {
    case .seriesDetails(let id):
      let service = DetailsService(dependencies: dependencies)
      let viewModel = DetailsViewModel(
        id: id, 
        mediaType: "tv",
        service: service,
        repository: DetailsRepository()
      )
      SeriesDetailsView(
        viewModel: viewModel,
        dependencies: dependencies,
        coordinator: self
      )
    case .moviesDetails(id: let id):
      let service = DetailsService(dependencies: dependencies)
      let viewModel = DetailsViewModel(
        id: id,
        mediaType: "movie",
        service: service,
        repository: DetailsRepository()
      )
      MoviesDetailsView(
        viewModel: viewModel,
        dependencies: dependencies,
        coordinator: self
      )
    case .reviews(id: let id, let type):
      let reviewsCoordinator = ReviewsCoordinator(dependencies: dependencies)
      reviewsCoordinator.get(page: .home(mediaType: type, id: id))
    }
  }
}

public enum Page: Identifiable, Hashable {
  case seriesDetails(id: Int)
  case moviesDetails(id: Int)
  case reviews(id: Int, type: String)
  public var id: String {
    ID(describing: self)
  }
}
