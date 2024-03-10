import Dependencies
import Foundation
import SwiftUI

public final class MoviesViewFactory {
  var dependencies: Dependencies
  var coordinator: MoviesCoordinator
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
    self.coordinator = MoviesCoordinator(dependencies: dependencies)
  }
  
  public func makeMainView() -> some View {
    let service = MoviesService(dependencies: dependencies)
    let viewModel = MoviesMainViewModel(service: service)
    return MoviesMainView(viewModel: viewModel, dependencies: dependencies)
  }
  
  public func makeMovieDetailsView(id: Int) -> some View {
    let service = MovieDetailsService(dependencies: dependencies)
    let viewModel = MovieDetailsViewModel(id: id, service: service)
    return MovieDetailsView(viewModel: viewModel, dependencies: dependencies)
  }
}
