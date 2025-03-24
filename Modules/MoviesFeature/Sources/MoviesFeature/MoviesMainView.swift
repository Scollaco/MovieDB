import ComposableArchitecture
import Details
import Foundation
import Networking
import Utilities
import Routing
import UIComponents
import SwiftUI
import CoreData

public struct MoviesMainView: View {
  @Bindable var store: StoreOf<MoviesFeature>
  
  private weak var coordinator: MoviesCoordinator?
  
  init(
    store: StoreOf<MoviesFeature>,
    coordinator: MoviesCoordinator
  ) {
    self.store = store
    self.coordinator = coordinator
  }
  
  public var body: some View {
    CollectionLoadingView(
      state: mapToCollectionState(),
      content: { items in
        ScrollView(showsIndicators: false) {
          ListSection(
            title: "Trending this week",
            category: .trending,
            items: store.trendingMovies,
            coordinator: coordinator,
            store: store
          )
          .padding(.bottom)
          
          ListSection(
            title: "Popular",
            category: .popular,
            items: store.popularMovies,
            coordinator: coordinator,
            store: store
          )
          .padding(.bottom)
          
          ListSection(
            title: "Top Rated",
            category: .topRated,
            items: store.topRatedMovies,
            coordinator: coordinator,
            store: store
          )
          .padding(.bottom)
          
          ListSection(
            title: "Now Playing",
            category: .nowPlaying,
            items: store.nowPlayingMovies,
            coordinator: coordinator,
            store: store
          )
          .padding(.bottom)
          
          ListSection(
            title: "Upcoming",
            category: .upcoming,
            items: store.upcomingMovies,
            coordinator: coordinator,
            store: store
          )
          .padding(.bottom)
        }
        .listRowSpacing(10)
      },
      empty: {
        Text("No results found.")
          .bold()
      },
      error: { error in
        Text("Error: \(error.localizedDescription)")
          .bold()
      }
    )
    .onAppear {
      store.send(.onAppear)
    }
    .navigationDestination(
      item: $store.scope(state: \.destination?.details, action: \.destination.details)
    ) { detailsStore in
      MovieDetailsView(store: detailsStore)
    }
  }
  
  func mapToCollectionState() -> CollectionLoadingState<Any> {
    return store.isLoading ?
      .loading(
        placeholder:
          ListSection(
            title: "Top Rated",
            category: .topRated,
            items: [.mock()],
            coordinator: coordinator,
            store: store
          )
          .padding(.bottom)
      ) :
      .loaded(content: store.trendingMovies)
  }
}

struct ListSection: View {
  let title: String
  let category: MovieSection
  let items: [Movie]
  let coordinator: MoviesCoordinator?
  let store: StoreOf<MoviesFeature>
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.title) { movie in
                ImageViewCell(
                  imageUrl: movie.imageUrl,
                  title: movie.title,
                  date: movie.formattedDate,
                  rating: movie.voteAverage
                )
                .onTapGesture {
                  store.send(.movieSelected(movie.id))
                  // coordinator?.goToDetails(id: movie.id)
                }
//                .onAppear {
//                  if store.shouldLoadMoreData(movie.id, items: items) {
//                    store.send(.loadMoreData(for: category))
//                  }
//                }
          }
        }
      }
    } header: {
      Text(title)
        .font(.title2)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
  }
}

extension MoviesFeature.State {
  func shouldLoadMoreData(_ movieId: Int, items: [Movie]) -> Bool {
    guard items.count > 10 else { return false }
    let targetItem = items[items.count - 5]
    return movieId == targetItem.id
  }
}

//#Preview {
//  MoviesMainView(
//    viewModel: MoviesMainViewModel(service: MockService())
//  )
//}
