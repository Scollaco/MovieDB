import Foundation
import Dependencies
import UIComponents
import SwiftUI
import CoreData

struct MoviesMainView: View {
  @ObservedObject private var viewModel: MoviesMainViewModel
  
  init(viewModel: MoviesMainViewModel) {
    self.viewModel = viewModel
  }
  public var body: some View {
    ScrollView(showsIndicators: false) {
      ListSection(
        title: "Now Playing",
        category: .nowPlaying,
        viewModel: viewModel,
        items: $viewModel.nowPlayingMovies
      )
      ListSection(
        title: "Top Rated",
        category: .topRated,
        viewModel: viewModel,
        items: $viewModel.topRatedMovies
      )
      ListSection(
        title: "Popular",
        category: .popular,
        viewModel: viewModel,
        items: $viewModel.popularMovies
      )
      ListSection(
        title: "Upcoming",
        category: .upcoming,
        viewModel: viewModel,
        items: $viewModel.upcomingMovies
      )
    }
    .listRowSpacing(10)
    .onAppear {
      viewModel.fetchMovies()
    }
  }
}

struct ListSection: View {
  let title: String
  let category: Category
  let viewModel: MoviesMainViewModel
  @Binding var items: [Movie]
  
  @State private var scrollPosition: CGFloat = .zero
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach($items, id: \.id) { movie in
            ImageView(movie: movie)
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
    .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
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
//
//#Preview {
//  MoviesMainView()
//}
//
//
