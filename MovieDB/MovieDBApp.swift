import Core
import Dependencies
import ImageProvider
import Networking
import SwiftUI

@main
struct MovieDBApp: App {
    var body: some Scene {
        WindowGroup {
          TabView {
            ContentView()
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

