import Foundation
import Dependencies
import UIComponents
import SwiftUI
import CoreData

struct SearchView: View {
  @ObservedObject private var viewModel: SearchViewModel
  @State private var searchTerm: String = .init()
  
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    let layout = [
      GridItem(.fixed(110)),
      GridItem(.fixed(110)),
      GridItem(.fixed(110))
    ]
    ScrollView {
      LazyVGrid(columns: layout) {
        ForEach($viewModel.results, id: \.id) { result in
          SearchCell(result: result)
        }
      }
      .searchable(
        text: $viewModel.debouncedQuery,
        prompt: "Search movies and series"
      )
      .onChange(of: $viewModel.debouncedQuery.wrappedValue) { _ in
        viewModel.search()
      }
    }
    .scrollDismissesKeyboard(.immediately)
  }
}

struct SearchCell: View {
  @Binding var result: SearchResult
  
  var body: some View {
    VStack {
      if let url = URL(string: result.imageUrl) {
        CacheAsyncImage(url: url) { phase in
          switch phase {
          case .failure:
            Image(
              systemName: result.mediaType == .movie ? "movieclapper" : "tv"
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
        Image(
          systemName: result.mediaType == .movie ? "movieclapper" : "tv"
        )
        .frame(height: 165)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      Text(result.title ?? result.name ?? "")
        .font(.footnote)
    }
  }
}
