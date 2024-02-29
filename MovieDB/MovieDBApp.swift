import Core
import Dependencies
import Details
import ImageProvider
import MoviesFeature
import Networking
import Routing
import SeriesFeature
import SwiftUI
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

private let moviesViewsFactory: MoviesViewFactory = {
  MoviesViewFactory(dependencies: MovieDBApp.dependencies)
}()

private let seriesView: some View = {
  let factory = SeriesViewFactory(dependencies: MovieDBApp.dependencies)
  return factory.makeMainView()
}()

//private func detailsView(movie: Movie) -> some View {
//  let factory = DetailsViewFactory(dependencies: MovieDBApp.dependencies)
//  return factory.makeDetailsView(movie: movie)
//}

struct DiscoverView: View {
  @Binding var path: NavigationPath
  var body: some View {
    NavigationStack(path: $path) {
      TopTabBarView(titles: ["Movies", "TV Series"]) {
        moviesViewsFactory.makeMainView()
          .withMovieRoutes(dependencies: MovieDBApp.dependencies)
          .tag(0)
        
        seriesView
          .withDetailsRoutes()
          .tag(1)
      }
      .navigationTitle("Discover")
    }
    .tabItem { Label("Discover", systemImage: "movieclapper") }
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
