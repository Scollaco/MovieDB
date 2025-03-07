import Foundation
import MovieDBDependencies
import Routing
import UIComponents
import SwiftUI
import CoreData

struct SearchView: View {
  @ObservedObject private var viewModel: SearchViewModel
  private let dependencies: MovieDBDependencies
  public weak var coordinator: SearchCoordinator?

  init(
    viewModel: SearchViewModel,
    dependencies: MovieDBDependencies,
    coordinator: SearchCoordinator
  ) {
    self.viewModel = viewModel
    self.dependencies = dependencies
    self.coordinator = coordinator
  }
  
  var body: some View {
    let layout = [
      GridItem(.fixed(110), alignment: .top),
      GridItem(.fixed(110), alignment: .top),
      GridItem(.fixed(110), alignment: .top)
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
                .onAppear {
                  if viewModel.shouldLoadMoreData(result.id.wrappedValue) {
                    viewModel.loadMoreData()
                  }
                }
        }
      }
      Spacer(minLength: 200)
      if viewModel.centerTextVisible {
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
