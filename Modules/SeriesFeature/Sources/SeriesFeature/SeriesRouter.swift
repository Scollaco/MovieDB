import Foundation
import Dependencies
import SwiftUI

protocol ModuleRouter {
  var appRouter: RouterInterface { get }
}

public enum SeriesExit: Hashable {
  case details(Int, String)
}

final public class SeriesRouter: ModuleRouter {
  private(set) var appRouter: RouterInterface
  
  public init(with appRouter: RouterInterface) {
    self.appRouter = appRouter
  }
  
  func navigate(to target: SeriesExit) {
    appRouter.navigate(to: target)
  }
  
  func pop() {
    appRouter.pop()
  }
}

public extension View {
  func withSeriesRoutes(dependencies: Dependencies) -> some View {
    let factory = SeriesViewFactory(dependencies: dependencies)
    return navigationDestination(for: SeriesExit.self) { destination in
      switch destination {
      case .details(let series):
        factory.makeSeriesDetailsView(series: series)
      }
    }
  }
}
