import SwiftUI
import MoviesFeature
import SeriesFeature
import UIComponents

public struct WatchlistView: View {
  @ObservedObject var viewModel = WatchlistViewModel(
    moviesRepository: MovieRepository(),
    seriesRepository: SeriesRepository()
  )
  
  public init() {}
  
  public var body: some View {
    ScrollView {
      if viewModel.moviesSectionIsVisible {
        Section {
          ScrollView(showsIndicators: false) {
            VStack {
              ForEach($viewModel.movies, id: \.title) { movie in
                HStack(alignment: .top) {
                  ImageViewCell(
                    imageUrl: movie.wrappedValue.imageUrl,
                    title: movie.wrappedValue.title
                  )
                  Text(movie.wrappedValue.overview)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                  Button {
                    viewModel.delete(movie: movie.wrappedValue)
                  } label: {
                    Image(systemName: "bookmark.fill")
                  }
                }
              }
            }
          }
        } header: {
          Text("Movies")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
      }
    }
    .onAppear {
      viewModel.fetchData()
    }
  }
}
