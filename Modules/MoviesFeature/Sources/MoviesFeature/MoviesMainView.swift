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
        items: $viewModel.nowPlayingMovies
      )
      .padding(.bottom)
      
      ListSection(
        title: "Top Rated",
        category: .topRated,
        viewModel: viewModel,
        router: router,
        items: $viewModel.topRatedMovies
      )
      .padding(.bottom)
      
      ListSection(
        title: "Popular",
        category: .popular,
        viewModel: viewModel,
        router: router,
        items: $viewModel.popularMovies
      )
      
      ListSection(
        title: "Upcoming",
        category: .upcoming,
        viewModel: viewModel,
        router: router,
        items: $viewModel.upcomingMovies
      )
      .padding(.bottom)
    }
    .listRowSpacing(10)
  }
}

struct ListSection: View {
  let title: String
  let category: Category
  let viewModel: MoviesMainViewModel
  let router: MoviesRouter
  @Binding var items: [Movie]
  
  @State private var scrollPosition: CGFloat = .zero
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach($items, id: \.id) { movie in
            ImageView(
              movie: movie
            )
              .onAppear {
                if viewModel.shouldLoadMoreData(movie.id, items: items) {
                  viewModel.loadMoreData(for: category)
                }
              }
              .onTapGesture {
                router.navigate(to: .details(movie.wrappedValue))
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

struct ImageView: View {
  @Binding var movie: Movie
  
  var body: some View {
    VStack {
      if let url = URL(string: movie.imageUrl) {
        CacheAsyncImage(url: url) { phase in
          switch phase {
          case .failure:
            Image(systemName: "photo") .font(.largeTitle)
          case .success(let image):
            image.resizable()
          default:
            ProgressView()
          }
        }
        .frame(height: 165)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      
      Text(movie.title)
        .font(.footnote)
        .lineLimit(1)
        .bold()
      
      Text(movie.formattedDate)
        .font(.caption2)
        .foregroundStyle(.gray)
     }
    .frame(width: 110)
  }
}

//#Preview {
//  MoviesMainView()
//}
//

