import ComposableArchitecture
import Storage
import SwiftUI
import UIComponents
import Reviews
import Routing
import AVKit

public struct MovieDetailsView: View {
  @Bindable var store: StoreOf<DetailsFeature>
  
  public init(store: StoreOf<DetailsFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 10) {
        if let url = store.movieDetails?.trailerURL {
          VideoPlayerView(videoUrl: url)
            .frame(height: 230)
        }
        
        Text(store.movieDetails?.title ?? .init())
          .font(.title2)
          .bold()
          .multilineTextAlignment(.center)
        
        if let tagline = store.movieDetails?.tagline {
          Text(tagline)
            .font(.caption)
            .bold()
            .padding(.horizontal)
            .multilineTextAlignment(.center)
        }
       
        if store.overviewIsVisible {
          ExpandableText(text: store.movieDetails?.overview ?? .init(), compactedLineLimit: 6)
            .font(.footnote)
            .padding()
          
        }
        
        if store.directorsRowIsVisible {
          VStack(alignment: .leading) {
            HStack {
              Text("Created by:")
                .font(.caption)
                .bold()
             Spacer()
            }
            ScrollView(.horizontal) {
              HStack(spacing: 10) {
                ForEach(store.movieDetails?.createdBy ?? [], id: \.id) { creator in
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
        
        if store.genreListIsVisible {
          VStack {
            HStack {
              Text("Genres:")
                .font(.caption)
                .bold()
              Spacer()
            }
            ScrollView(.horizontal) {
              HStack {
                ForEach(store.movieDetails?.genres ?? [], id: \.id) { genre in
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
        
        if store.reviewsSectionIsVisible {
          Button {
            store.send(.reviewsButtonTapped)
          } label: {
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
          }
          .padding(.horizontal)
        }
        
        if !store.providers.isEmpty {
          ProvidersSection(items: store.providers)
        }
        
        ScrollView(showsIndicators: false) {
          if let similar = store.movieDetails?.similar.results,
             !similar.isEmpty {
            MovieDetailListSection(
              store: store,
              title: "Similar Movies",
              items: similar
            )
            .padding(.bottom)
          }
       
          if let recommended = store.movieDetails?.recommendations.results,
              !recommended.isEmpty {
            MovieDetailListSection(
              store: store,
              title: "People Also Watched",
              items: recommended
            )
            .padding(.bottom)
          }
        }
        .padding()
      }
    }
    .toolbar {
      if let details = store.movieDetails,
         let url = details.shareUrl {
        ShareLink(
            item: url,
            message: Text(""),
            preview: SharePreview(
              details.title,
              image: Image(systemName: "square.and.arrow.up")
            )
          )
        }
      Button(action: {
        store.send(.bookmarkButtonTapped)
      }, label: {
        Image(systemName: store.watchlistIconName)
      }
      )
    }
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      store.send(.onAppear(.movie, store.id))
    }
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.reviews,
        action: \.destination.reviews
      )
    ) { reviewsStore in
      ReviewsMainView(store: reviewsStore)
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
  @Bindable var store: StoreOf<DetailsFeature>
  let title: String
  var items: [Details]
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(items, id: \.id) { movie in
            MoviesBottomSheet(
              movie: movie,
              store: store
            )
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
  var movie: Details
  @Bindable var store: StoreOf<DetailsFeature>

  var body: some View {
    Button {
      store.send(.onSelectingItem(.movie, movie.id))
    } label: {
      ImageViewCell(
        imageUrl: movie.imageUrl,
        title: movie.title ?? "",
        placeholder: "movieclapper"
      )
    }
    .sheet(
      item: $store.scope(state: \.destination?.details, action: \.destination.details)
    ) { detailsStore in
      MovieDetailsView(store: detailsStore)
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
