import ComposableArchitecture
import Details
import Foundation
import UIComponents
import SwiftUI

struct SearchView: View {
  @Bindable var store: StoreOf<SearchFeature>
  
  init(store: StoreOf<SearchFeature>) {
    self.store = store
  }
  
  var body: some View {
    let layout = [
      GridItem(.fixed(110), alignment: .top),
      GridItem(.fixed(110), alignment: .top),
      GridItem(.fixed(110), alignment: .top)
    ]
    
    ScrollView {
      LazyVGrid(columns: layout) {
        ForEach(store.results, id: \.id) { result in
              SearchCell(result: result)
                .tag(result.id)
                .onTapGesture {
                  store.send(.cellSelected(result.id, result.mediaType))
                }
                .onAppear {
                  store.send(.cellDidAppear(result.id))
                }
        }
      }
      Spacer(minLength: 200)
      if store.centerTextVisible {
        EmptyStateView(
          title: "Find movies and series",
          subtitle: "Search for titles to find your favorite movies and series."
        )
      }
    }
    .scrollDismissesKeyboard(.immediately)
    .searchable(
      text: $store.query,
      prompt: "Search movies and series"
    )
    .onChange(of: store.query) {
      store.send(.search)
    }
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.details,
        action: \.destination.details
      )
    ) { detailsStore in
      if store.selectedMediaType == .movie {
        MovieDetailsView(store: detailsStore)
      } else {
        SeriesDetailsView(store: detailsStore)
      }
    }
  }
}

struct SearchCell: View {
  var result: SearchResult
  
  var body: some View {
    let placeholder = result.mediaType.placeholder
    VStack {
      if let url = URL(string: result.imageUrl) {
        CacheAsyncImage(url: url) { phase in
          switch phase {
          case .failure:
            Image(
              systemName: placeholder
            )
          case .success(let image):
            image.resizable()
          default:
            ProgressView()
          }
        }
        .frame(height: 165)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      } else {
        Image(systemName: placeholder)
          .frame(height: 165)
          .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      Text(result.title ?? result.name ?? "")
        .font(.footnote)
        .bold()
        .padding()
    }
  }
}

//#Preview {
//  SearchView(
//    viewModel: SearchViewModel(service: MockService())
//  )
//}
