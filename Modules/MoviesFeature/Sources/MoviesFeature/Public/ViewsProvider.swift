import Dependencies
import SwiftUI

public final class ViewsProvider {
  private let dependencies: Dependencies
  private let coordinator: MoviesCoordinator
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    coordinator = MoviesCoordinator(dependencies: dependencies)
  }
  
  public func provideMainView() -> any View {
    coordinator.get(page: .home)
  }
}
