import SwiftUI
import UIComponents
import Routing
import Dependencies
import AVKit

public struct MoviesDetailsView: View {
  @ObservedObject private var viewModel: DetailsViewModel
  private let dependencies: Dependencies
  public weak var coordinator: DetailsCoordinator?

  public init(
    viewModel: DetailsViewModel,
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
        
      }, label: {
        Image.init(systemName: "square.and.arrow.up")
      }
      )
      Button(action: {
        
      }, label: {
        Image(systemName: "bookmark")
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
  let items: [Details]
  let dependencies: Dependencies
  let coordinator: DetailsCoordinator?
  
  @State private var isPresenting = false
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { details in
            Button(action: {
              isPresenting = true
            }, label: {
              ImageViewCell(
                imageUrl: details.imageUrl,
                title: details.title,
                date: "details.formattedDate",
                placeholder: "movieclapper"
              )
            })
            .sheet(isPresented: $isPresenting) {}
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
