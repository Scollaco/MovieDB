import SwiftUI
import UIComponents
import YouTubePlayerKit

struct MovieDetailsView: View {
  @ObservedObject private var viewModel: MoviesDetailsViewModel
  
  public init(viewModel: MoviesDetailsViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 10) {
        if let url = $viewModel.details.wrappedValue?.trailerURL {
          YouTubePlayerView(
            YouTubePlayer(stringLiteral: url.absoluteString)
          )
          .frame(height: 320)
        }
        
        Text($viewModel.details.wrappedValue?.title ?? .init())
          .font(.title2)
          .bold()
          .multilineTextAlignment(.center)
        
        if let tagline = $viewModel.details.wrappedValue?.tagline {
          Text(tagline)
            .font(.caption)
            .bold()
            .padding(.horizontal)
            .multilineTextAlignment(.center)
        }
        
        Text($viewModel.details.wrappedValue?.overview ?? .init())
          .font(.footnote)
          .padding()
          
        Text("Watch Now")
          .font(.title3)
          .bold()
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach($viewModel.providers, id: \.providerId) { provider in
              ProviderCell(provider: provider)
            }
          }
        }
        .padding()
        
        ScrollView(showsIndicators: false) {
            DetailListSection(
              title: "Similar Movies",
              items: $viewModel.similarMovies
            )
            .padding(.bottom)
            
            DetailListSection(
              title: "People Also Watched",
              items: $viewModel.recommendatedMovies
            )
            .padding(.bottom)
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

struct ProviderCell: View {
  @Binding var provider: WatchProvider
  
  var body: some View {
    if let url = URL(string: provider.logoUrl) {
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
      .frame(width: 40, height: 40)
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
  }
}

struct DetailListSection: View {
  let title: String
  @Binding var items: [Movie]
  
  @State private var scrollPosition: CGFloat = .zero
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach($items, id: \.id) { movie in
            ImageView(movie: movie)
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
//  DetailsView(movie: Movie)
//}
