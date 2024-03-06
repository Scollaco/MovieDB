import Combine
import Foundation

final class SearchViewModel: ObservableObject {
  private let service: Service
  private var bag = Set<AnyCancellable>()
  
  @Published var results: [SearchResult] = []
  @Published var debouncedQuery: String = .init()
  
  
  public init(service: Service) {
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
  private func performSearch(query: String) async throws  {
    let response = try await service.search(
      query: query, page: 1)
    let sortedResults = response
      .results
    results = sortedResults
  }
}
