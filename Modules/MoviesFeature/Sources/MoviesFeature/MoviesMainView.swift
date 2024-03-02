import Foundation
import Dependencies
import Utilities
import UIComponents
import SwiftUI
import CoreData

struct MoviesMainView: View {
  @ObservedObject private var viewModel: MoviesMainViewModel
  private var router: MoviesRouter
  
  init(viewModel: MoviesMainViewModel, router: MoviesRouter) {
    self.viewModel = viewModel
    self.router = router
  }
  public var body: some View {
    ScrollView(showsIndicators: false) {
      ListSection(
        title: "Now Playing",
        category: .nowPlaying,
        viewModel: viewModel,
        router: router,
        items: $viewModel.nowPlayingMovies.wrappedValue
      )
      .padding(.bottom)
      
      ListSection(
        title: "Top Rated",
        category: .topRated,
        viewModel: viewModel,
        router: router,
        items: $viewModel.topRatedMovies.wrappedValue
      )
      .padding(.bottom)
      
      ListSection(
        title: "Popular",
        category: .popular,
        viewModel: viewModel,
        router: router,
        items: $viewModel.popularMovies.wrappedValue
      )
      
      ListSection(
        title: "Upcoming",
        category: .upcoming,
        viewModel: viewModel,
        router: router,
        items: $viewModel.upcomingMovies.wrappedValue
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
  let router: MoviesRouter
  let items: [Movie]
    
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.title) { movie in
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
              .onTapGesture {
                router.navigate(to: .details(movie))
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

#Preview {
  MoviesMainView(
    viewModel:  MoviesMainViewModel(service: MockService()),
    router: MoviesRouter()
  )
}


