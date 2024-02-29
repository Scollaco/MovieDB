import Dependencies
import Foundation
import SwiftUI

public final class MoviesViewFactory {
  var dependencies: Dependencies
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func makeMainView() -> some View {
    let service = MoviesService(dependencies: dependencies)
    let viewModel = MoviesMainViewModel(service: service)
    return MoviesMainView(viewModel: viewModel, router: MoviesRouter(with: dependencies.router))
  }
  
  public func makeMovieDetailsView(movie: Movie) -> some View {
    let service = MoviesService(dependencies: dependencies)
    let viewModel = MoviesDetailsViewModel(movie: movie, service: service)
    return MovieDetailsView(viewModel: viewModel)
  }
}
