import Foundation
import Dependencies
import SwiftUI

protocol ModuleRouter {
  var appRouter: RouterInterface? { get }
}

public enum SearchExit: Hashable {
  case details(Int, String)
}

final public class SearchRouter: ModuleRouter {
  private(set) var appRouter: RouterInterface?
  
  public init(with appRouter: RouterInterface? = nil) {
    self.appRouter = appRouter
  }
  
  func navigate(to target: SearchExit) {
    appRouter?.navigate(to: target)
  }
  
  func pop() {
    appRouter?.pop()
  }
}
