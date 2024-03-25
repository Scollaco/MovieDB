import Dependencies
import Foundation
import Routing
import SwiftUI
import Details

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
      let detailsCoordinator = DetailsCoordinator(dependencies: dependencies)
      return detailsCoordinator.get(page: .movieDetails(id: id))
    case .tv:
      let detailsCoordinator = DetailsCoordinator(dependencies: dependencies)
      return detailsCoordinator.get(page: .seriesDetails(id: id))
    case .unknown:
      assertionFailure("Unknown type")
      return EmptyView()
    }
  }
}
