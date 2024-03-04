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
}
