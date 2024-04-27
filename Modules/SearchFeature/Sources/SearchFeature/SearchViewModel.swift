import Combine
import Foundation

final class SearchViewModel: ObservableObject {
  private let service: Service
  private var bag = Set<AnyCancellable>()
  private var nextResultsPage: Int = 1
  
  @Published var results: [SearchResult] = []
  @Published var debouncedQuery: String = .init()
  @Published var centerTextVisible: Bool = true
  
  
  init(service: Service) {
    self.service = service
  }
  
  @MainActor
  func search() {
    $debouncedQuery
      .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
      .sink(receiveValue: { [weak self] value in
        Task {
          do {
            try await self?.performSearch(query: value)
          } catch {
            print(error)
          }
        }
      })
      .store(in: &bag)
  }
  
  @MainActor
  private func performSearch(query: String, isNewSearch: Bool = true) async throws  {
    let response = try await service.search(
      query: query, page: nextResultsPage)
    nextResultsPage = response.page + 1
    let sortedResults = response
      .results
    if isNewSearch {
      results = sortedResults
      nextResultsPage = 1
    } else {
      results.append(contentsOf: sortedResults)
    }
    centerTextVisible = results.isEmpty
  }
  
  func shouldLoadMoreData(_ id: Int) -> Bool {
    guard results.count > 10  else { return false }
    // Fetch more data when list is approaching the end
    let targetItem = results[results.count - 5]
    return id == targetItem.id
  }
  
  func loadMoreData() {
    Task { @MainActor in
      try? await performSearch(query: debouncedQuery, isNewSearch: false)
    }
  }
}
