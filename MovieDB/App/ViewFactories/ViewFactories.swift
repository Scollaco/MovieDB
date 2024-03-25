import Core
import Networking
import MoviesFeature
import SeriesFeature
import SearchFeature
import Details
import Foundation

final class RootViewFactories {
  static let dependencies: ConcreteDependencies = {
    .init(
      network: NetworkImpl()
    )
  }()
  
  static let moviesViewsFactory: MoviesViewFactory = {
    MoviesViewFactory(dependencies: dependencies)
  }()

  static let seriesViewsFactory: SeriesViewFactory = {
    SeriesViewFactory(dependencies: dependencies)
  }()

  static let searchViewFactory: SearchViewFactory = {
    SearchViewFactory(dependencies: dependencies)
  }()
}
