import Foundation
import Dependencies
import Routing
import UIComponents
import SwiftUI
import CoreData

public struct SearchView: View {
  @ObservedObject private var viewModel: SearchViewModel
  private let dependencies: Dependencies
  public weak var coordinator: SearchCoordinator?

  init(
    viewModel: SearchViewModel,
    dependencies: Dependencies,
    coordinator: SearchCoordinator
  ) {
    self.viewModel = viewModel
    self.dependencies = dependencies
    self.coordinator = coordinator
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
                .tag(result.id.wrappedValue)
                .onTapGesture {
                  coordinator?.goToDetails(
                    id: result.id.wrappedValue,
                    type: result.wrappedValue.mediaType
                  )
                }
        }
      }
      Spacer(minLength: 200)
      if viewModel.searchLabelIsVisible {
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
    VStack {
      if let url = URL(string: result.imageUrl) {
        CacheAsyncImage(url: url) { phase in
          switch phase {
          case .failure:
            Image(
              systemName: result.placeholderImage
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
        Image(systemName: result.placeholderImage)
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
