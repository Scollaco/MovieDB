import Foundation
import Dependencies
import UIComponents
import SwiftUI
import CoreData

struct SearchView: View {
  @ObservedObject private var viewModel: SearchViewModel
  private var router: SearchRouter
  
  init(viewModel: SearchViewModel, router: SearchRouter) {
    self.viewModel = viewModel
    self.router = router
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
            .onTapGesture {
              router.navigate(
                to: .details(result.wrappedValue.id, result.wrappedValue.mediaType.rawValue)
              )
            }
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

#Preview {
  SearchView(
    viewModel: SearchViewModel(service: MockService()),
    router: SearchRouter()
  )
}
