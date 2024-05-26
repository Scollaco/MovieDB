import MovieDBDependencies
import Reviews
import Routing
import SwiftUI

public final class DetailsCoordinator: Coordinator, ObservableObject {
  @Published public var path = NavigationPath()
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
  
  func goToSeriesDetails(id: Int) {
    path.append(Page.seriesDetails(id: id))
  }
 
  func goToMoviesDetails(id: Int) {
    path.append(Page.movieDetails(id: id))
  }
  
  func goToReviews(id: Int, mediaType: String) {
    path.append(Page.reviews(id: id, type: mediaType))
  }
  
  // MARK: - View providers
  @ViewBuilder
  public func get(page: Page) -> some View {
    switch page {
    case .seriesDetails(let id):
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
    case .movieDetails(id: let id):
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
    case .reviews(id: let id, let type):
      let reviewsCoordinator = ReviewsCoordinator(dependencies: dependencies)
      reviewsCoordinator.get(page: .home(mediaType: type, id: id))
    }
  }
}

public enum Page: Identifiable, Hashable {
  case seriesDetails(id: Int)
  case movieDetails(id: Int)
  case reviews(id: Int, type: String)
  public var id: String {
    ID(describing: self)
  }
}
