import Core
import Dependencies
import Details
import ImageProvider
import MoviesFeature
import Networking
import Routing
import SeriesFeature
import SwiftUI
import SearchFeature
import UIComponents

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
        SearchView(path: $router.path)
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

private let moviesViewsFactory: MoviesViewFactory = {
  MoviesViewFactory(dependencies: MovieDBApp.dependencies)
}()

private let seriesViewsFactory: SeriesViewFactory = {
  SeriesViewFactory(dependencies: MovieDBApp.dependencies)
}()

private let searchViewFactory: SearchViewFactory = {
  SearchViewFactory(dependencies: MovieDBApp.dependencies)
}()

struct DiscoverView: View {
  @Binding var path: NavigationPath
  var body: some View {
    NavigationStack(path: $path) {
      TopTabBarView(titles: ["Movies", "TV Series"]) {
        moviesViewsFactory.makeMainView()
          .withMovieRoutes(dependencies: MovieDBApp.dependencies)
          .tag(0)
        
        seriesViewsFactory.makeMainView()
          .withSeriesRoutes(dependencies: MovieDBApp.dependencies)
          .tag(1)
      }
      .navigationTitle("Discover")
    }
    .tabItem { Label("Discover", systemImage: "movieclapper") }
  }
}

struct SearchView: View {
  @Binding var path: NavigationPath
  
  var body: some View {
    NavigationStack(path: $path) {
      searchViewFactory.makeSearchView()
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
