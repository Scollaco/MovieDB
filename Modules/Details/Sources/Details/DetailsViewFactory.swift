import Dependencies
import Foundation
import Routing
import SwiftUI

public enum MediaType: String {
  case movie
  case tv
}

public final class DetailsViewFactory {
  var dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  @ViewBuilder
  public func makeDetailsView(
    id: Int,
    type: String
  ) -> some View {
    EmptyView()
//    let service = DetailsService(dependencies: dependencies)
//    let viewModel = DetailsViewModel(id: id, mediaType: type, service: service)
//    let coordinator = MoviesCoordinator(dependencies: dependencies)
//    if type == "movie" {
//      MoviesDetailsView(
//        viewModel: viewModel,
//        dependencies: dependencies,
//        coordinator: coordinator
//      )
//    } else {
//      SeriesDetailsView(viewModel: viewModel, dependencies: dependencies)
//    }
  }
}
