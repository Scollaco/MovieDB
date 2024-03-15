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
  var body: some Scene {
    WindowGroup {
      TabView {
        DiscoverView(
          moviesCoordinator: MoviesCoordinator(
            dependencies: MovieDBApp.dependencies
          ),
          seriesCoordinator: SeriesCoordinator(
            dependencies: MovieDBApp.dependencies
          )
        )
        SearchView(
          searchCoordinator: SearchCoordinator(
            dependencies: MovieDBApp.dependencies
          )
        )
        TabView3()
      }
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
  @ObservedObject var moviesCoordinator: MoviesCoordinator
  @ObservedObject var seriesCoordinator: SeriesCoordinator

  var body: some View {
    NavigationStack {
      TopTabBarView(titles: ["Movies", "TV Series"]) {
        NavigationStack(path: $moviesCoordinator.path) {
          moviesCoordinator.get(page: .home)
            .navigationDestination(for: Page.self) {
              moviesCoordinator.get(page: $0)
            }
        }
        .tag(0)
        
        NavigationStack(path: $seriesCoordinator.path) {
          seriesCoordinator.get(page: .home)
            .navigationDestination(for: Page.self) {
              seriesCoordinator.get(page: $0)
            }
        }
        .tag(1)
      }
      .navigationTitle("Discover")
    }
    .tabItem {
      Label("Discover", systemImage: "movieclapper")
    }
  }
}

struct SearchView: View {
  @ObservedObject var searchCoordinator: SearchCoordinator

  var body: some View {
    NavigationStack {
      NavigationStack(path: $searchCoordinator.path) {
        searchCoordinator.get(page: .home)
          .navigationDestination(for: Page.self) {
            searchCoordinator.get(page: $0)
          }
          .navigationTitle("Search")
      }
      .tag(2)
    }
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
