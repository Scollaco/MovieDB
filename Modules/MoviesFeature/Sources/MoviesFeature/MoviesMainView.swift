import Dependencies
import Foundation
import Networking
import Utilities
import UIComponents
import SwiftUI
import CoreData

struct MoviesMainView: View {
  @ObservedObject private var viewModel: MoviesMainViewModel
  private let dependencies: Dependencies
  
  init(viewModel: MoviesMainViewModel, dependencies: Dependencies) {
    self.viewModel = viewModel
    self.dependencies = dependencies
  }
  
  public var body: some View {
    ScrollView(showsIndicators: false) {
      ListSection(
        title: "Now Playing",
        category: .nowPlaying,
        viewModel: viewModel,
        items: $viewModel.nowPlayingMovies.wrappedValue,
        dependencies: dependencies
      )
      .padding(.bottom)
      
      ListSection(
        title: "Top Rated",
        category: .topRated,
        viewModel: viewModel,
        items: $viewModel.topRatedMovies.wrappedValue,
        dependencies: dependencies
      )
      .padding(.bottom)
      
      ListSection(
        title: "Popular",
        category: .popular,
        viewModel: viewModel,
        items: $viewModel.popularMovies.wrappedValue,
        dependencies: dependencies
      )
      
      ListSection(
        title: "Upcoming",
        category: .upcoming,
        viewModel: viewModel,
        items: $viewModel.upcomingMovies.wrappedValue,
        dependencies: dependencies
      )
      .padding(.bottom)
    }
    .listRowSpacing(10)
  }
}

struct ListSection: View {
  let title: String
  let category: MovieSection
  let viewModel: MoviesMainViewModel
  let items: [Movie]
  let dependencies: Dependencies
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.title) { movie in
            NavigationLink(
              value: MoviesRoutes.details(id: movie.id, dependencies: dependencies),
              label: {
                ImageViewCell(
                  imageUrl: movie.imageUrl,
                  title: movie.title,
                  date: movie.formattedDate
                )
                .onAppear {
                  if viewModel.shouldLoadMoreData(movie.id, items: items) {
                    viewModel.loadMoreData(for: category)
                  }
                }
              })
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
