import Foundation
import Dependencies
import SwiftUI

public enum MoviesRoutes: Hashable, View {
  public static func == (lhs: MoviesRoutes, rhs: MoviesRoutes) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
  
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .details(id: let id, dependencies: _):
      hasher.combine(id)
    }
  }
  
  case details(id: Int, dependencies: Dependencies)

  public var body: some View {
    switch self {
    case .details(let id, let dependencies):
      let factory = MoviesViewFactory(dependencies: dependencies)
      return factory.makeMovieDetailsView(id: id)
    }
  }
}
