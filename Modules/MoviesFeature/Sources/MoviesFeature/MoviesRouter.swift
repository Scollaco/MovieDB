import Foundation
import Dependencies
import SwiftUI

protocol ModuleRouter {
  var appRouter: RouterInterface { get }
}

enum MoviesRoute: Hashable {
  case details
}

enum MoviesExit: Hashable {
  case details
}

final public class MoviesRouter: ModuleRouter {
  private(set) var appRouter: RouterInterface
  
  public init(with appRouter: RouterInterface) {
    self.appRouter = appRouter
  }
  
  func navigate(to target: MoviesRoute) {
    appRouter.navigate(to: target)
  }
  
  func pop() {
    appRouter.pop()
  }
}

// Custom view modifier for routing of this module
public extension View {
  func withMovieRoutes() -> some View {
        self.navigationDestination(for: MoviesRoute.self) { destination in
            switch destination {
                case .details:
                  Text("Details view")
            }
        }
    }
}
