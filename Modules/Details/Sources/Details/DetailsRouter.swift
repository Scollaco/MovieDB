import Foundation
import Dependencies
import SwiftUI

public enum DetailsRoute: Hashable {
  public static func == (lhs: DetailsRoute, rhs: DetailsRoute) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(hashValue)
  }
  
  case details(id: Int, mediaType: String, dependencies: Dependencies)
}

extension DetailsRoute: View {
  public var body: some View {
    switch self {
    case .details(let id, let mediaType, let dependencies):
      let factory = DetailsViewFactory.init(dependencies: dependencies)
      factory.makeDetailsView(id: id, type: mediaType)
    }
  }
}
