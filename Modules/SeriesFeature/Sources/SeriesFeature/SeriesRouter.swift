import Foundation
import Dependencies
import SwiftUI

protocol ModuleRouter {
  var appRouter: RouterInterface { get }
}

public enum SeriesRoute: Hashable {
  case details(Series)
}

final public class SeriesRouter: ModuleRouter {
  private(set) var appRouter: RouterInterface
  
  public init(with appRouter: RouterInterface) {
    self.appRouter = appRouter
  }
  
  func navigate(to target: SeriesRoute) {
    appRouter.navigate(to: target)
  }
  
  func pop() {
    appRouter.pop()
  }
}

public extension View {
  func withSeriesRoutes(dependencies: Dependencies) -> some View {
    let factory = SeriesViewFactory(dependencies: dependencies)
    return self.navigationDestination(for: SeriesRoute.self) { destination in
      switch destination {
      case .details(let series):
        factory.makeSeriesDetailsView(series: series)
      }
    }
  }
}
