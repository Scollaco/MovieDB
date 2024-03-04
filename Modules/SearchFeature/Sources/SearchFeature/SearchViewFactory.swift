import Dependencies
import Foundation
import SwiftUI

public final class SearchViewFactory {
  var dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func makeSearchView() -> some View {
    let service = SearchService(dependencies: dependencies)
    let viewModel = SearchViewModel(service: service)
    return SearchView(viewModel: viewModel, router: SearchRouter(with: dependencies.router))
  }
}
