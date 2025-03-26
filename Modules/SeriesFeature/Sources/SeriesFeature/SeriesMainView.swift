import ComposableArchitecture
import Details
import MovieDBDependencies
import Reviews
import SwiftUI
import UIComponents
import Utilities

struct SeriesMainView: View {
  @Bindable var store: StoreOf<SeriesFeature>

  init(store: StoreOf<SeriesFeature>) {
    self.store = store
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      ListSection(
        title: "Trending this week",
        category: .trending,
        items: store.trendingSeries,
        store: store
      )
      .padding(.bottom)
      
      ListSection(
        title: "Airing today",
        category: .airingToday,
        items: store.airingTodaySeries,
        store: store
      )
      .padding(.bottom)
      
      ListSection(
        title: "Top rated",
        category: .topRated,
        items: store.topRatedSeries,
        store: store
      )
      .padding(.bottom)
      
      ListSection(
        title: "Popular",
        category: .popular,
        items: store.popularSeries,
        store: store
      )
      .padding(.bottom)
      
      ListSection(
        title: "On the air",
        category: .onTheAir,
        items: store.onTheAirSeries,
        store: store
      )
      .padding(.bottom)
    }
    .listRowSpacing(10)
    .onAppear {
      store.send(.onAppear)
    }
    .navigationDestination(
      item: $store.scope(state: \.destination?.details, action: \.destination.details)
    ) { detailsStore in
      SeriesDetailsView(store: detailsStore)
    }
  }
}

struct ListSection: View {
  let title: String
  let category: SeriesCategory
  let items: [Series]
  let store: StoreOf<SeriesFeature>
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { series in
            ImageViewCell(
              imageUrl: series.imageUrl,
              title: series.name,
              rating: series.voteAverage
            )
            .onTapGesture {
              store.send(.seriesSelected(series.id))
            }
            .onAppear {
              store.send(.cellDidAppear(series.id, category))
            }
          }
        }
      }
    } header: {
      SectionHeader(title: title)
    }
    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
  }
}

//#Preview {
//  SeriesMainView(
//    viewModel: SeriesMainViewModel(service: MockService())
//  )
//}
