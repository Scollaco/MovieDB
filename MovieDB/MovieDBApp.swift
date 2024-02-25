import UIComponents
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
            TopTabBarView(titles: ["Movies", "Series", "TV"]) {
              
              Color.clear
              
              moviesView(with: dependencies)
                .background(.background)
                .tag(0)
              
              Text("Series")
                .tag(1)
              
              Text("TV")
                .tag(2)
            }
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

