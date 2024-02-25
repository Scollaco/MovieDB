import Core
import Dependencies
import ImageProvider
import MoviesFeature
import Networking
import SwiftUI

@main
struct MovieDBApp: App {
    var body: some Scene {
      lazy var dependencies: Dependencies = {
        makeDependencies()
      }()
        WindowGroup {
          TabView {
            moviesView(with: dependencies)
              .background(.background)
              .tabItem { Label("Discover", systemImage: "movieclapper") }
              
            ContentView2()
              .tabItem { Label("Series", systemImage: "2.circle") }
          }
          
        }
    }
  
  private func moviesView(with dependencies: Dependencies) -> some View {
    let factory = MoviesViewFactory(dependencies: dependencies)
    return factory.makeMainView()
  }
  
  func makeDependencies() -> ConcreteDependencies {
    .init(
      network: NetworkImpl(),
      imageProvider: ImageProviderImpl()
    )
  }
}

