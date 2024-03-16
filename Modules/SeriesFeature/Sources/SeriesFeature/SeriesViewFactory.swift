import Dependencies
import Foundation
import Routing
import SwiftUI

public final class SeriesViewFactory {
  var dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  @ViewBuilder
  public func makeMainView() -> some View {
    let service = SeriesService(dependencies: dependencies)
    let coordinator = SeriesCoordinator(dependencies: dependencies)
    let viewModel = SeriesMainViewModel(service: service)
    SeriesMainView(
      viewModel: viewModel,
      dependencies: dependencies,
      coordinator: coordinator
    )
  }
  
  @ViewBuilder
  public func makeSeriesDetailsView(id: Int) -> some View {
    let service = SeriesDetailsService(dependencies: dependencies)
    let viewModel = SeriesDetailsViewModel(
      id: id,
      service: service,
      repository: SeriesRepository()
    )
    let coordinator = SeriesCoordinator(dependencies: dependencies)
    SeriesDetailsView(
      viewModel: viewModel,
      dependencies: dependencies,
      coordinator: coordinator
    )
  }
}
