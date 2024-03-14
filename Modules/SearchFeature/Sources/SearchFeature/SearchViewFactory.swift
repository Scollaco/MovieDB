import Dependencies
import Foundation
import Routing
import SwiftUI
import MoviesFeature
import SeriesFeature

public final class SearchViewFactory {
  var dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func makeSearchView() -> SearchView {
    let service = SearchService(dependencies: dependencies)
    let viewModel = SearchViewModel(service: service)
    let coordinator = SearchCoordinator(dependencies: dependencies)
    return SearchView(
      viewModel: viewModel,
      dependencies: dependencies,
      coordinator: coordinator
    )
  }
  
  func makeSearchDetailsView(
    id: Int,
    mediaType: MediaType,
    dependencies: Dependencies
  ) -> any View {
    switch mediaType {
    case .movie:
      let factory = MoviesViewFactory(dependencies: dependencies)
      return factory.makeMovieDetailsView(id: id)
    case .tv:
      let factory = SeriesViewFactory(dependencies: dependencies)
      return factory.makeSeriesDetailsView(id: id)
    case .unknown:
      assertionFailure("Unknown type")
      return EmptyView()
    }
  }
}
