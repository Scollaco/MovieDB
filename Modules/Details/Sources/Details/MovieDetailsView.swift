import Dependencies
import Storage
import SwiftUI
import UIComponents
import Routing
import AVKit

public struct MovieDetailsView: View {
  @ObservedObject private var viewModel: MovieDetailsViewModel
  private let dependencies: Dependencies
  private weak var coordinator: DetailsCoordinator?
  
  init(
    viewModel: MovieDetailsViewModel,
    dependencies: Dependencies,
    coordinator: DetailsCoordinator
  ) {
    self.viewModel = viewModel
    self.dependencies = dependencies
    self.coordinator = coordinator
  }
  
  public var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 10) {
        if let url = $viewModel.movieDetails.wrappedValue?.trailerURL {
          VideoPlayerView(videoUrl: url)
            .frame(height: 230)
        }
        
        Text($viewModel.movieDetails.wrappedValue?.title ?? .init())
          .font(.title2)
          .bold()
          .multilineTextAlignment(.center)
        
        if let tagline = $viewModel.movieDetails.wrappedValue?.tagline {
          Text(tagline)
            .font(.caption)
            .bold()
            .padding(.horizontal)
            .multilineTextAlignment(.center)
        }
        
        ExpandableText(text: $viewModel.movieDetails.wrappedValue?.overview ?? .init(), compactedLineLimit: 6)
          .font(.footnote)
          .padding()
        
        if $viewModel.reviewsSectionIsVisible.wrappedValue,
           let id = viewModel.movieDetails?.id {
          NavigationLink(destination: {
            coordinator?.get(page: .reviews(id: id, type: "movie"))
          }, label: {
            HStack {
              Text("Reviews")
                .bold()
              Spacer()
              Image.init(systemName: "chevron.forward")
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .tint(.primary)
          })
          .padding(.horizontal)
        }
        
        if !$viewModel.providers.isEmpty {
          ProvidersSection(items: $viewModel.providers)
        }
        
        ScrollView(showsIndicators: false) {
          if !$viewModel.similarMovies.isEmpty {
            MovieDetailListSection(
              title: "Similar Movies",
              dependencies: dependencies,
              coordinator: coordinator,
              items: $viewModel.similarMovies
            )
            .padding(.bottom)
          }
       
          if !$viewModel.recommendatedMovies.isEmpty {
            MovieDetailListSection(
              title: "People Also Watched",
              dependencies: dependencies,
              coordinator: coordinator,
              items: $viewModel.recommendatedMovies
            )
            .padding(.bottom)
          }
        }
        .padding()
      }
    }
    .toolbar {
      Button(action: {
        viewModel.addMovieToWatchlist()
      }, label: {
        Image(systemName: viewModel.watchlistIconName)
      }
      )
    }
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.fetchMovieDetails()
    }
  }
}

struct MovieDetailListSection: View {
  let title: String
  let dependencies: Dependencies
  let coordinator: DetailsCoordinator?
  @Binding var items: [Details]
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach($items, id: \.id) { movie in
            MoviesBottomSheet(movie: movie.wrappedValue, coordinator: coordinator)
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

struct MoviesBottomSheet: View {
  @State private var isPresenting = false
  var movie: Details
  let coordinator: DetailsCoordinator?

  var body: some View {
    Button(action: {
      isPresenting.toggle()
    }, label: {
      ImageViewCell(
        imageUrl: movie.imageUrl,
        title: movie.title ?? "",
        placeholder: "movieclapper"
      )
    })
    .sheet(isPresented: $isPresenting) {
      coordinator?.get(page: .movieDetails(id: movie.id))
    }
  }
}

//#Preview {
//  MoviesDetailsView(
//    viewModel: DetailsViewModel(
//      id: 1,
//      mediaType: .movie,
//      service: MockService()
//    )
//  )
//}
