import Dependencies
import Foundation
import Networking
import Utilities
import Routing
import UIComponents
import SwiftUI
import CoreData

public struct MoviesMainView: View {
  @ObservedObject private var viewModel: MoviesMainViewModel
  private let dependencies: Dependencies
  private weak var coordinator: MoviesCoordinator?
  
  init(
    viewModel: MoviesMainViewModel,
    dependencies: Dependencies,
    coordinator: MoviesCoordinator
  ) {
    self.viewModel = viewModel
    self.dependencies = dependencies
    self.coordinator = coordinator
  }
  
  public var body: some View {
    CollectionLoadingView(
      state: mapToCollectionState(viewModel),
      content: { items in
        ScrollView(showsIndicators: false) {
          ListSection(
            title: "Trending this week",
            category: .trending,
            viewModel: viewModel,
            items: $viewModel.trendingMovies.wrappedValue,
            dependencies: dependencies,
            coordinator: coordinator
          )
          .padding(.bottom)
          
          ListSection(
            title: "Popular",
            category: .popular,
            viewModel: viewModel,
            items: $viewModel.popularMovies.wrappedValue,
            dependencies: dependencies,
            coordinator: coordinator
          )
          .padding(.bottom)
          
          ListSection(
            title: "Top Rated",
            category: .topRated,
            viewModel: viewModel,
            items: $viewModel.topRatedMovies.wrappedValue,
            dependencies: dependencies,
            coordinator: coordinator
          )
          .padding(.bottom)
          
          ListSection(
            title: "Now Playing",
            category: .nowPlaying,
            viewModel: viewModel,
            items: $viewModel.nowPlayingMovies.wrappedValue,
            dependencies: dependencies,
            coordinator: coordinator
          )
          .padding(.bottom)
          
          ListSection(
            title: "Upcoming",
            category: .upcoming,
            viewModel: viewModel,
            items: $viewModel.upcomingMovies.wrappedValue,
            dependencies: dependencies,
            coordinator: coordinator
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
  }
  
  func mapToCollectionState(_ viewModel: MoviesMainViewModel) -> CollectionLoadingState<Any> {
    let state = viewModel.state
    switch state {
    case .loading:
      return .loading(
        placeholder:
          ListSection(
            title: "Top Rated",
            category: .topRated,
            viewModel: viewModel,
            items: [.mock()],
            dependencies: dependencies,
            coordinator: coordinator
          )
          .padding(.bottom)
      )
    case .loaded:
      return .loaded(content: $viewModel.trendingMovies.wrappedValue)
    case .empty:
      return .empty
    case .error(let error):
      return .error(error)
    }
  }
}

struct ListSection: View {
  let title: String
  let category: MovieSection
  let viewModel: MoviesMainViewModel
  let items: [Movie]
  let dependencies: Dependencies
  let coordinator: MoviesCoordinator?
  
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
                  coordinator?.goToDetails(id: movie.id)
                }
                .onAppear {
                  if viewModel.shouldLoadMoreData(movie.id, items: items) {
                    viewModel.loadMoreData(for: category)
                  }
                }
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

//#Preview {
//  MoviesMainView(
//    viewModel: MoviesMainViewModel(service: MockService())
//  )
//}
