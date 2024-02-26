import UIComponents
import Core
import Dependencies
import ImageProvider
import MoviesFeature
import Networking
import Routing
import SwiftUI

@main
struct MovieDBApp: App {
  @ObservedObject var router: AppRouter
  init() {
    self.router = MovieDBApp.dependencies.router as! AppRouter
  }
  
  var body: some Scene {
    WindowGroup {
      TabView {
        DiscoverView(path: $router.path)
        TabView2(path: $router.path)
        TabView3(path: $router.path)
      }
      .navigationBarTitleDisplayMode(.large)
    }
  }
  
  static let dependencies: ConcreteDependencies = {
    .init(
      network: NetworkImpl(),
      imageProvider: ImageProviderImpl(),
      router: AppRouter(path: .init())
    )
  }()
}

struct DiscoverView: View {
  @Binding var path: NavigationPath
  
  var body: some View {
    NavigationStack(path: $path) {
      TopTabBarView(titles: ["Movies", "Series", "TV"]) {
        moviesView()
          .withMovieRoutes()
          .tag(0)
        
        Text("Series")
          .tag(1)
        
        Text("TV")
          .tag(2)
      }
      .navigationTitle("Discover")
    }
    .tabItem { Label("Discover", systemImage: "movieclapper") }
  }
  
  private func moviesView() -> some View {
    let factory = MoviesViewFactory(dependencies: MovieDBApp.dependencies)
    return factory.makeMainView()
  }
}

struct TabView2: View {
  @Binding var path: NavigationPath
  
  var body: some View {
    NavigationStack(path: $path) {
      ContentView2()
        .navigationTitle("Search")
    }
    .tabItem { Label("Search", systemImage: "magnifyingglass") }
  }
}

struct TabView3: View {
  @Binding var path: NavigationPath
  
  var body: some View {
    NavigationStack(path: $path) {
      ContentView()
        .navigationTitle("Watchlist")
    }
    .tabItem { Label("Watchlist", systemImage: "bookmark") }
  }
}
