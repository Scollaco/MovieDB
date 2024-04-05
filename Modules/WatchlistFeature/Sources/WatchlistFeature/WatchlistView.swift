import SwiftUI
import Details
import UIComponents

struct WatchlistView: View {
  @ObservedObject var viewModel: WatchlistViewModel
  public weak var coordinator: WatchlistCoordinator?

  init(
    viewModel: WatchlistViewModel,
    coordinator: WatchlistCoordinator
  ) {
    self.viewModel = viewModel
    self.coordinator = coordinator
  }
  
  var body: some View {
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
                .onTapGesture {
                  coordinator?.goToDetails(id: movie.wrappedValue.id, type: .movie)
                }
              }
            }
          }
        } header: {
          SectionHeader(title: "Movies")
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
                .onTapGesture {
                  coordinator?.goToDetails(id: series.wrappedValue.id, type: .tv)
                }
              }
            }
          }
        } header: {
          SectionHeader(title: "Series")
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
