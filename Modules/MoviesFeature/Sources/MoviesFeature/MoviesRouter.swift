import Foundation
import Dependencies
import SwiftUI

protocol ModuleRouter {
  var appRouter: RouterInterface? { get }
}

public enum MoviesRoute: Hashable {
  case details(Movie)
}

public enum MoviesExit: Hashable {
  case details(Movie)
}

final public class MoviesRouter: ModuleRouter {
  private(set) var appRouter: RouterInterface?
  
  public init(with appRouter: RouterInterface? = nil) {
    self.appRouter = appRouter
  }
  
  func navigate(to target: MoviesRoute) {
    appRouter?.navigate(to: target)
  }
  
  func pop() {
    appRouter?.pop()
  }
}

public extension View {
  func withMovieRoutes(dependencies: Dependencies) -> some View {
    let factory = MoviesViewFactory(dependencies: dependencies)
    return self.navigationDestination(for: MoviesRoute.self) { destination in
      switch destination {
      case .details(let movie):
        factory.makeMovieDetailsView(movie: movie)
      }
    }
  }
}
