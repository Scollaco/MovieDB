import Dependencies
import Foundation
import SwiftUI

public final class SeriesViewFactory {
  var dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func makeMainView() -> some View {
    let service = SeriesService(dependencies: dependencies)
    let viewModel = SeriesMainViewModel(service: service)
    return SeriesMainView(viewModel: viewModel, router: SeriesRouter(with: dependencies.router))
  }
  
  public func makeSeriesDetailsView(series: Series) -> some View {
    let service = SeriesService(dependencies: dependencies)
    let viewModel = SeriesDetailsViewModel(series: series, service: service)
    return SeriesDetailsView(viewModel: viewModel)
  }
}
