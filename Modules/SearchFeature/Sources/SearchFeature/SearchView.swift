import Foundation
import Dependencies
import UIComponents
import SwiftUI
import CoreData

struct SearchView: View {
  @ObservedObject private var viewModel: SearchViewModel
  private let dependencies: Dependencies
  
  init(viewModel: SearchViewModel, dependencies: Dependencies) {
    self.viewModel = viewModel
    self.dependencies = dependencies
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
          NavigationLink(
            value: SearchRoutes.details(
              id: result.wrappedValue.id,
              mediaType: result.wrappedValue.mediaType,
              dependencies: dependencies
            ),
            label: {
              SearchCell(result: result)
                .tag(result.id.wrappedValue)
            })
        }
      }
      Spacer(minLength: 200)
      VStack {
        Text("Find movies and series")
          .font(.title)
          .bold()
        Text("Search for titles to find your favorite movies and series.")
          .multilineTextAlignment(.center)
      }
      .padding()
      .foregroundColor(.gray)
    }
    .scrollDismissesKeyboard(.immediately)
    .searchable(
      text: $viewModel.debouncedQuery,
      prompt: "Search movies and series"
    )
    .onChange(of: $viewModel.debouncedQuery.wrappedValue) { _ in
      viewModel.search()
    }
  }
}

struct SearchCell: View {
  @Binding var result: SearchResult
  
  var body: some View {
    let placeholder = result.mediaType == .movie ? "movieclapper" : "tv"
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
