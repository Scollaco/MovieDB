import Foundation
import Dependencies
import SwiftUI

public enum SeriesRoutes: Hashable, View {
  public static func == (lhs: SeriesRoutes, rhs: SeriesRoutes) -> Bool {
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
      let factory = SeriesViewFactory(dependencies: dependencies)
      return factory.makeSeriesDetailsView(id: id)
    }
  }
}
