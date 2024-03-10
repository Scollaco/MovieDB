import Foundation
import Dependencies
import SwiftUI

public enum SearchRoutes: Hashable, View {
  public static func == (lhs: SearchRoutes, rhs: SearchRoutes) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
  
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .details(id: let id, mediaType: let mediaType, dependencies: _):
      hasher.combine(id)
      hasher.combine(mediaType)
    }
  }
  
  case details(
    id: Int,
    mediaType: SearchResult.MediaType?,
    dependencies: Dependencies
  )
  
  public var body: some View {
    switch self {
    case .details(let id, let type, let dependencies):
      let factory = SearchViewFactory(dependencies: dependencies)
      return factory.makeSearchDetailsView(
        id: id,
        mediaType: type,
        dependencies: dependencies
      )
      .navigationLinkValues(SearchRoutes.self)
    }
  }
}
