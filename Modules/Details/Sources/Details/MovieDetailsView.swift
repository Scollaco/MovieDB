import Dependencies
import Storage
import SwiftUI
import UIComponents
import Routing
import AVKit

struct MovieDetailsView: View {
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
  
  var body: some View {
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
       
        if $viewModel.overviewIsVisible.wrappedValue {
          ExpandableText(text: $viewModel.movieDetails.wrappedValue?.overview ?? .init(), compactedLineLimit: 6)
            .font(.footnote)
            .padding()
          
        }
        
        if $viewModel.directorsRowIsVisible.wrappedValue {
          VStack(alignment: .leading) {
            HStack {
              Text("Created by:")
                .font(.caption)
                .bold()
             Spacer()
            }
            ScrollView(.horizontal) {
              HStack(spacing: 10) {
                ForEach(viewModel.movieDetails?.createdBy ?? [], id: \.id) { creator in
                  ImageCapsuleView(
                    imageUrl: creator.profileImageUrl,
                    text: creator.name
                  )
                }
              }
              .padding(.horizontal)
            }
          }
          .scrollIndicators(.hidden)
        }
        
        if $viewModel.genreListIsVisible.wrappedValue {
          VStack {
            HStack {
              Text("Genres:")
                .font(.caption)
                .bold()
              Spacer()
            }
            ScrollView(.horizontal) {
              HStack {
                ForEach(viewModel.movieDetails?.genres ?? [], id: \.id) { genre in
                  Text(genre.name)
                    .font(.caption)
                    .bold()
                    .padding(.horizontal)
                    .background(.quaternary)
                    .clipShape(.capsule)
                }
              }
              Spacer()
            }
          }
          .scrollIndicators(.hidden)
          .padding(.horizontal)
        }
        
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
      if let details = viewModel.movieDetails,
         let url = details.shareUrl {
          ShareLink(
            item: url,
            message: Text(viewModel.shareDetails),
            preview: SharePreview(
              details.title,
              image: Image(systemName: "square.and.arrow.up")
            )
          )
        }
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

struct ImageCapsuleView: View {
  let imageUrl: String?
  let text: String
  private let placeholder = Image(systemName: "person")
  var body: some View {
      HStack {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
          CacheAsyncImage(url: url) { phase in
            switch phase {
            case .failure:
              placeholder
            case .success(let image):
              image.resizable()
            default:
              ProgressView()
            }
          }
          .aspectRatio(contentMode: .fill)
          .frame(width: 30, height: 30)
          .clipShape(.circle)
        } else {
          placeholder
            .frame(width: 30, height: 30)
        }
        Text(text)
          .font(.caption)
          .tint(.primary)
          .bold()
      }
      .background(
        GeometryReader { textGeometry in
          Capsule(style: .circular)
            .foregroundStyle(.quaternary)
            .frame(width: textGeometry.size.width + 10)
        }
      )
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
        HStack {
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
