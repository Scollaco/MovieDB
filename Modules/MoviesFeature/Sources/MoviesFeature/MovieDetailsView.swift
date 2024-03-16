import Dependencies
import Storage
import SwiftUI
import UIComponents
import Routing
import AVKit

public struct MovieDetailsView: View {
  @ObservedObject private var viewModel: MovieDetailsViewModel
  private let dependencies: Dependencies
  private weak var coordinator: MoviesCoordinator?
  private let repository: MovieRepositoryInterface
  
  init(
    viewModel: MovieDetailsViewModel,
    dependencies: Dependencies,
    coordinator: MoviesCoordinator,
    repository: MovieRepositoryInterface
  ) {
    self.viewModel = viewModel
    self.dependencies = dependencies
    self.coordinator = coordinator
    self.repository = repository
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
        
        Text($viewModel.movieDetails.wrappedValue?.overview ?? .init())
          .font(.footnote)
          .padding()
        
        if !$viewModel.providers.isEmpty {
          ProvidersSection(
            items: $viewModel.providers,
            dependencies: dependencies
          )
        }
        
        ScrollView(showsIndicators: false) {
          if !$viewModel.similarMovies.isEmpty {
            MovieDetailListSection(
              title: "Similar Movies",
              items: $viewModel.similarMovies.wrappedValue,
              dependencies: dependencies,
              coordinator: coordinator
            )
            .padding(.bottom)
          }
       
          if !$viewModel.recommendatedMovies.isEmpty {
            MovieDetailListSection(
              title: "People Also Watched",
              items: $viewModel.recommendatedMovies.wrappedValue,
              dependencies: dependencies,
              coordinator: coordinator
            )
            .padding(.bottom)
          }
        }
        .padding()
      }
    }
    .toolbar {
      Button(action: {
        if let details = viewModel.movieDetails {
          _ = repository.create(movie: details)
        }
      }, label: {
        Image.init(systemName: "bookmark")
      }
      )
    }
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.fetchMovieDetails()
    }
  }
}

struct ProvidersSection: View {
  @Binding var items: [WatchProvider]
  let dependencies: Dependencies

  var body: some View {
    Text("Watch Now")
      .font(.title3)
      .bold()
    
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach($items, id: \.providerId) { provider in
          ProviderCell(url: provider.wrappedValue.logoUrl)
        }
      }
    }
    .padding()
  }
}

struct MovieDetailListSection: View {
  let title: String
  let items: [Movie]
  let dependencies: Dependencies
  let coordinator: MoviesCoordinator?
  @State private var isPresenting = false
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { movie in
            Button(action: {
              isPresenting = true
            }, label: {
              ImageViewCell(
                imageUrl: movie.imageUrl,
                title: movie.title,
                date: movie.formattedDate,
                placeholder: "movieclapper"
              )
            })
            .sheet(isPresented: $isPresenting) {
              coordinator?.get(page: .details(id: movie.id))
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
//  MoviesDetailsView(
//    viewModel: DetailsViewModel(
//      id: 1,
//      mediaType: .movie,
//      service: MockService()
//    )
//  )
//}
