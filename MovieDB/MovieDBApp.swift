import Core
import MovieDBDependencies
import Details
import MoviesFeature
import Networking
import Routing
import SearchFeature
import SeriesFeature
import SwiftUI
import WatchlistFeature
import UIComponents

@main
struct MovieDBApp: App {
  var body: some Scene {
    lazy var dependencies: MovieDBDependencies = {
      ConcreteDependencies(network: NetworkImpl())
    }()
    
    WindowGroup {
      TabView {
        DiscoverView(
          moviesCoordinator: MoviesCoordinator(
            dependencies: dependencies
          ),
          seriesCoordinator: SeriesCoordinator(
            dependencies: dependencies
          )
        )
        SearchView(
          searchCoordinator: SearchCoordinator(
            dependencies: dependencies
          )
        )
        WatchlistView(
          watchlistCoordinator: WatchlistCoordinator(
            dependencies: dependencies
          )
        )
      }
      .navigationBarTitleDisplayMode(.large)
    }
  }
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

struct WatchlistView: View {
  @ObservedObject var watchlistCoordinator: WatchlistCoordinator

  var body: some View {
    NavigationStack {
      NavigationStack(path: $watchlistCoordinator.path) {
        watchlistCoordinator.get(page: .home)
          .navigationDestination(for: Page.self) {
            watchlistCoordinator.get(page: $0)
          }
          .navigationTitle("Watchlist")
      }
      .tag(3)
    }
    .tabItem { Label("Watchlist", systemImage: "bookmark") }
  }
}
