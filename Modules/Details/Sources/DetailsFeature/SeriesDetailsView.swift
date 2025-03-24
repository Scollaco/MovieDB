import ComposableArchitecture
import SwiftUI
import MovieDBDependencies
import UIComponents
import Routing
import AVKit

struct SeriesDetailsView: View {
  private let dependencies: MovieDBDependencies
  
  @Bindable var store: StoreOf<DetailsFeature>
  
  init(
    store: StoreOf<DetailsFeature>,
    dependencies: MovieDBDependencies
  ) {
    self.store = store
    self.dependencies = dependencies
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
          
        if store.reviewsSectionIsVisible,
           let id = store.seriesDetails?.id {
          NavigationLink(destination: {
            // coordinator?.get(page: .reviews(id: id, type: "tv"))
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
          
          if let similar = store.movieDetails?.similar.results,
             !similar.isEmpty {
            DetailListSection(
              store: store,
              title: "Similar Series",
              items: similar,
              dependencies: dependencies
            )
            .padding(.bottom)
          }
          
          if let recommended = store.movieDetails?.recommendations.results,
              !recommended.isEmpty {
            DetailListSection(
              store: store,
              title: "People Also Watched",
              items: recommended,
              dependencies: dependencies
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
      Button(action: {
        store.send(.bookmarkButtonTapped)
      }, label: {
        Image(systemName: store.watchlistIconName)
      }
      )
    }
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      if let id = store.seriesDetails?.id {
        store.send(.onAppear(.tv, id))
      }
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
  let dependencies: MovieDBDependencies
  @State private var isPresenting = false
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(items, id: \.id) { item in
            BottomSheet(store: store, dependencies: dependencies, item: item)
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
  private let dependencies: MovieDBDependencies
  var item: Details
  
  init(store: StoreOf<DetailsFeature>, dependencies: MovieDBDependencies, item: Details) {
    self.store = store
    self.dependencies = dependencies
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
      SeriesDetailsView(store: detailsStore, dependencies: dependencies)
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
