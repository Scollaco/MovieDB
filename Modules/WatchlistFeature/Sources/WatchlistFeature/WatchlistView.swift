import ComposableArchitecture
import Details
import SwiftUI
import UIComponents
import Utilities

public struct WatchlistView: View {
  var store: StoreOf<WatchlistFeature>
  
  public init(store: StoreOf<WatchlistFeature>) {
    self.store = store
  }
  
  public var body: some View {
    List {
      Section {
        ForEach(store.movies) { movie in
          WatchlistSection.init(media: movie, store: store)
            .listRowBackground(Color.clear)
            .padding(.bottom, 10)
        }
      } header: {
        SectionHeader(title: "Movies")
      }
      .headerProminence(.increased)
      .hide(if: !store.moviesSectionIsVisible)
      
      Section {
        ForEach(store.series) { series in
          WatchlistSection.init(media: series, store: store)
            .listRowBackground(Color.clear)
            .padding(.bottom, 10)
        }
      } header: {
        SectionHeader(title: "Series")
      }
      .headerProminence(.increased)
      .hide(if: !store.seriesSectionIsVisible)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

struct WatchlistSection: View {
  let media: MediaProjection
  var store: StoreOf<WatchlistFeature>

  var body: some View {
    WatchlistItem(
      imageUrl: media.imageUrl,
      title: media.title,
      overview: media.overview
    )
    .onTapGesture {
      store.send(.bookmarkSelected(media.id, media.mediaType))
    }
    .listRowSeparator(.hidden)
    .listRowInsets(.init())
    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
      Button("Delete", role: .destructive) {
        store.send(.deleteButtonTapped(media.id))
      }
      .tint(.red)
    }
    .padding(.bottom, 15)
    .padding(.horizontal)
    .listRowBackground(Color.clear)
    .padding(.bottom)
  }
}

struct WatchlistItem: View {
  let imageUrl: String
  let title: String
  let overview: String
  
  var body: some View {
    HStack(alignment: .top) {
      ImageViewCell(
        imageUrl: imageUrl,
        title: title
      )
      Text(overview)
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
  }
}
