import ComposableArchitecture
import Dependencies
import Details
import Foundation

@Reducer
public struct SearchFeature {
  @Dependency(\.searchClient) var client
  @Dependency(\.mainRunLoop) var  mainRunLoop
  
  @Reducer
  public enum Destination {
    case details(DetailsFeature)
  }
  
  @ObservableState
  public struct State {
    @Presents var destination: Destination.State?

    var nextResultsPage: Int
    var isNewSearch: Bool
    var results: [SearchResult]
    var centerTextVisible: Bool
    var detailsState: DetailsFeature.State
    var selectedMediaType:  MediaType
    var query: String
    
    init(
      destination: Destination.State? = nil,
      detailsState: DetailsFeature.State = .init(),
      isNewSearch: Bool = true,
      nextResultsPage: Int = 1,
      results: [SearchResult] = [],
      centerTextVisible: Bool = true,
      selectedMediaType: MediaType = .unknown,
      query: String = ""
    ) {
      self.destination = destination
      self.detailsState = detailsState
      self.isNewSearch = isNewSearch
      self.nextResultsPage = nextResultsPage
      self.results = results
      self.centerTextVisible = centerTextVisible
      self.selectedMediaType = selectedMediaType
      self.query = query
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case cellDidAppear(Int)
    case cellSelected(Int, MediaType)
    case destination(PresentationAction<Destination.Action>)
    case details(DetailsFeature.Action)
    case onAppear
    case search
    case searchResult(Result<SearchResultResponse, Error>)
  }
  
  public init() {}
  
  private enum SearchDebounceID: Hashable {
    case id
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.detailsState, action: \.details) {
      DetailsFeature()
    }
    Reduce { state, action in
      switch action {
      case .cellDidAppear(let id):
        let shouldLoadMoreData = shouldLoadMoreData(id: id, results: state.results)
        if shouldLoadMoreData {
          state.isNewSearch = false
          return search(for: state.query, page: state.nextResultsPage)
        }
        return .none
      case .cellSelected(let id, let mediaType):
        guard mediaType == .movie || mediaType == .tv else {
          return .none
        }
        state.selectedMediaType = mediaType
        state.destination = .details(
          .init(
            id: id,
            mediaType: mediaType == .movie ? .movie : .tv
          )
        )
        return .none
      case .details, .destination:
        return .none
      case .onAppear:
        state.centerTextVisible = state.results.isEmpty
        return .none
      case .search:
        state.isNewSearch = true
        return search(for: state.query, page: state.nextResultsPage)
          .debounce(
            id: SearchDebounceID.id,
            for: .milliseconds(500),
            scheduler: mainRunLoop
          )
      case .searchResult(.success(let response)):
        print("Next search page: \(response.page)")
        if state.isNewSearch {
          state.results = response.results
          state.nextResultsPage = 1
        } else {
          state.nextResultsPage = response.page + 1
          state.results.append(contentsOf: response.results)
        }
        return .none
      case .searchResult(.failure(let error)):
        print("[SearchFeature] Error: \(error)")
        return .none
      case .binding:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
  
  private func search(for query: String, page: Int) -> Effect<Self.Action> {
    .run { [client] send in
      await send(
        .searchResult(
          Result {
            return try await client.search(query, page)
          }
        )
      )
    }
  }
  
  private func shouldLoadMoreData(id: Int, results: [SearchResult]) -> Bool {
    guard results.count > 10 else {
      return false
    }
    let targetItem = results[results.count - 3]
    return id == targetItem.id
  }
}
