import Core
import Dependencies
import ImageProvider
import MoviesFeature
import Networking
import SwiftUI

@main
struct MovieDBApp: App {
    var body: some Scene {
        WindowGroup {
          TabView {
            MoviesMainView(dependencies: makeDependencies())
              .background(.yellow)
              .tabItem { Label("Movies", systemImage: "1.circle") }
              
            ContentView2()
              .tabItem { Label("Series", systemImage: "2.circle") }
          }
          
        }
    }
  
  func makeDependencies() -> ConcreteDependencies {
    .init(
      network: NetworkImpl(),
      imageProvider: ImageProviderImpl()
    )
  }
}

