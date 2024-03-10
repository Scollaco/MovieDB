import Core
import Dependencies
import Details
import MoviesFeature
import Networking
import Routing
import SearchFeature
import SeriesFeature
import SwiftUI
import UIComponents

@main
struct MovieDBApp: App {
  init() {}
  
  var body: some Scene {
    WindowGroup {
      TabView {
        DiscoverView()
        SearchView()
        TabView3()
      }
      .environmentObject(NetworkImpl())
      .navigationBarTitleDisplayMode(.large)
    }
  }
  
  static let dependencies: ConcreteDependencies = {
    .init(
      network: NetworkImpl()
    )
  }()
}

struct DiscoverView: View {
  var body: some View {
    NavigationStack {
      TopTabBarView(titles: ["Movies", "TV Series"]) {
        moviesViewsFactory.makeMainView()
          .tag(0)
        
        seriesViewsFactory.makeMainView()
          .navigationLinkValues(SeriesRoutes.self)
          .tag(1)
      }
      .navigationTitle("Discover")
    }
    .tabItem { Label("Discover", systemImage: "movieclapper") }
  }
}

struct SearchView: View {
  var body: some View {
      searchViewFactory.makeSearchView()
        .navigationLinkValues(SearchRoutes.self)
        .navigationTitle("Search")
        .tabItem { Label("Search", systemImage: "magnifyingglass") }
  }
}

struct TabView3: View {  
  var body: some View {
    NavigationStack {
      ContentView()
        .navigationTitle("Watchlist")
    }
    .tabItem { Label("Watchlist", systemImage: "bookmark") }
  }
}
