import ComposableArchitecture
import SwiftUI
import MovieDBDependencies
import UIComponents
import Reviews
import AVKit

public struct SeriesDetailsView: View {
  @Bindable var store: StoreOf<DetailsFeature>
  
  public init(store: StoreOf<DetailsFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 10) {
        if let url = store.seriesDetails?.trailerURL {
          VideoPlayerView(videoUrl: url)
            .frame(height: 230)
        }
        
        Text(store.seriesDetails?.name ?? .init())
          .font(.title2)
          .bold()
          .multilineTextAlignment(.center)
          .padding()
        
        if let tagline = store.seriesDetails?.tagline, !tagline.isEmpty {
          Text(tagline)
            .font(.caption)
            .bold()
            .padding(.horizontal)
            .multilineTextAlignment(.center)
        }
        
        if store.overviewIsVisible {
          ExpandableText(text: store.seriesDetails?.overview ?? .init(), compactedLineLimit: 6)
            .font(.footnote)
            .padding()
        }
        
        if store.directorsRowIsVisible {
          VStack {
            HStack {
              Text("Created by:")
                .font(.caption)
                .bold()
                .padding(.leading)
              Spacer()
            }
            ScrollView(.horizontal) {
              HStack {
                ForEach(store.seriesDetails?.createdBy ?? [], id: \.id) { creator in
                  ImageCapsuleView(
                    imageUrl: creator.profileImageUrl,
                    text: creator.name
                  )
                  .padding(.trailing)
                }
              }
              .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
          }
          .padding(.bottom)
        }
        
        if store.genreListIsVisible {
          VStack {
            HStack {
              Text("Genres")
                .font(.caption)
                .bold()
              Spacer()
            }
            ScrollView(.horizontal) {
              HStack {
                ForEach(store.seriesDetails?.genres ?? [], id: \.id) { genre in
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
        
        Divider()
            .background(.quaternary)
          
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
          if !store.seasons.isEmpty {
            SeasonListSection(
              title: "Seasons",
              items: store.seasons
            )
            .padding(.bottom)
          }
          
          if let similar = store.seriesDetails?.similar?.results,
             !similar.isEmpty {
            DetailListSection(
              store: store,
              title: "Similar Series",
              items: similar
            )
            .padding(.bottom)
          }
          
          if let recommended = store.seriesDetails?.recommendations?.results,
              !recommended.isEmpty {
            DetailListSection(
              store: store,
              title: "People Also Watched",
              items: recommended
            )
          }
        }
        .padding()
      }
    }
    .toolbar {
      if let details = store.seriesDetails,
         let url = details.shareUrl {
          ShareLink(
            item: url,
            message:
              Text(""),//store.shareDetails),
            preview: SharePreview(
              details.name,
              image: Image(systemName: "square.and.arrow.up")
            )
          )
        }
      Button {
        store.send(.bookmarkButtonTapped)
      } label: {
        Image(systemName: store.watchlistIconName)
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
        store.send(.onAppear(.tv, store.id))
    }
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.reviews,
        action: \.destination.reviews
      )) { reviewsStore in
      ReviewsMainView(store: reviewsStore)
    }
  }
}

struct SeasonListSection: View {
  let title: String
  let items: [SeriesDetails.Season]
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { season in
            ImageViewCell(
              imageUrl: season.imageUrl,
              title: season.name,
              placeholder: "tv"
            )
          }
        }
      }
    }  header: {
      Text(title)
        .font(.title2)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct DetailListSection: View {
  @Bindable var store: StoreOf<DetailsFeature>
  let title: String
  let items: [Details]
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(items, id: \.id) { item in
            BottomSheet(store: store, item: item)
          }
        }
      }
    }  header: {
      Text(title)
        .font(.title2)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct BottomSheet: View {
  @Bindable var store: StoreOf<DetailsFeature>
  var item: Details
  
  init(store: StoreOf<DetailsFeature>, item: Details) {
    self.store = store
    self.item = item
  }

  var body: some View {
    Button {
      store.send(.onSelectingItem(.tv, item.id))
    } label: {
      ImageViewCell(
        imageUrl: item.imageUrl,
        title: item.title ?? item.name ?? "",
        placeholder: "tv"
      )
    }
    .sheet(item: $store.scope(state: \.destination?.details, action: \.destination.details)) { detailsStore in
      SeriesDetailsView(store: detailsStore)
    }
  }
}

//#Preview {
//  SeriesDetailsView(
//    viewModel: SeriesDetailsViewModel(
//      series: .mock(),
//      service: MockService())
//  )
//}
