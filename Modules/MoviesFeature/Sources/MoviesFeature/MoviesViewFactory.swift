import Dependencies
import Routing
import Foundation
import SwiftUI

public final class MoviesViewFactory {
  var dependencies: Dependencies
  var coordinator: MoviesCoordinator
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
    coordinator = MoviesCoordinator(dependencies: dependencies)
  }
  
  @ViewBuilder
  public func makeMainView() -> some View {
    let service = MoviesService(dependencies: dependencies)
    let viewModel = MoviesMainViewModel(service: service)
    MoviesMainView(
      viewModel: viewModel,
      dependencies: dependencies,
      coordinator: coordinator
    )
  }
}
