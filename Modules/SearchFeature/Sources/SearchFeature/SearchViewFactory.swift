import Dependencies
import Foundation
import SwiftUI
import MoviesFeature
import SeriesFeature

public final class SearchViewFactory {
  var dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func makeSearchView() -> some View {
    let service = SearchService(dependencies: dependencies)
    let viewModel = SearchViewModel(service: service)
    return SearchView(viewModel: viewModel, dependencies: dependencies)
  }
  
  @ViewBuilder
  func makeSearchDetailsView(
    id: Int,
    mediaType: SearchResult.MediaType?,
    dependencies: Dependencies
  ) -> some View {
    switch mediaType {
    case .movie:
      let service = MovieDetailsService(dependencies: dependencies)
      let viewModel = MovieDetailsViewModel(id: id, service: service)
      MovieDetailsView(viewModel: viewModel, dependencies: dependencies)
    case .tv:
      let service = SeriesDetailsService(dependencies: dependencies)
      let viewModel = SeriesDetailsViewModel(id: id, service: service)
      SeriesDetailsView(viewModel: viewModel, dependencies: dependencies)
    case .none:
      EmptyView()
    }
  }
}
