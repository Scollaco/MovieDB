import Foundation
import Dependencies
import SwiftUI

protocol ModuleRouter {
  var appRouter: RouterInterface { get }
}

public enum MoviesExit: Hashable {
  case details
}

final public class MoviesRouter: ModuleRouter {
  private(set) var appRouter: RouterInterface
  
  public init(with appRouter: RouterInterface) {
    self.appRouter = appRouter
  }
  
  func navigate(to target: MoviesExit) {
    appRouter.navigate(to: target)
  }
  
  func pop() {
    appRouter.pop()
  }
}

public extension View {
  func withMovieRoutes() -> some View {
        self.navigationDestination(for: MoviesExit.self) { destination in
            switch destination {
                case .details:
                  Text("Details view")
            }
        }
    }
}
