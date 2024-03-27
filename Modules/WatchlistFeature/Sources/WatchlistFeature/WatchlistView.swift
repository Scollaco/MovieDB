import SwiftUI
import Details
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
                WatchlistItem(
                  imageUrl: movie.wrappedValue.imageUrl,
                  title: movie.wrappedValue.title,
                  overview: movie.wrappedValue.overview,
                  action: {
                    withAnimation {
                      viewModel.delete(movie: movie.wrappedValue)
                    }
                  }
                )
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
      
      if viewModel.seriesSectionIsVisible {
        Section {
          ScrollView(showsIndicators: false) {
            VStack {
              ForEach($viewModel.series, id: \.id) { series in
                WatchlistItem(
                  imageUrl: series.wrappedValue.imageUrl,
                  title: series.wrappedValue.name,
                  overview: series.wrappedValue.overview,
                  action: {
                    withAnimation {
                      viewModel.delete(series: series.wrappedValue)
                    }
                  }
                )
              }
            }
          }
        } header: {
          Text("Series")
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

struct WatchlistItem: View {
  let imageUrl: String
  let title: String
  let overview: String
  let action: () -> Void
  
  var body: some View {
    HStack(alignment: .top) {
      ImageViewCell(
        imageUrl: imageUrl,
        title: title
      )
      Text(overview)
        .font(.footnote)
        .foregroundStyle(.secondary)
      Button {
        action()
      } label: {
        Image(systemName: "bookmark.fill")
      }
    }
  }
}
