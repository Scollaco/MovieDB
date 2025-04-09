import ComposableArchitecture
import Dependencies
import Details
import Storage
import SwiftUI

@Reducer
public struct WatchlistFeature {
  @Dependency(\.detailsClient) var client
  
  @Reducer
  public enum Destination {
    case details(DetailsFeature)
  }
  
  @ObservableState
  public struct State {
    @Presents var destination: Destination.State?
    var detailsState: DetailsFeature.State
    var movies: [MediaProjection]
    var series: [MediaProjection]
    var centerTextVisible: Bool
    var moviesSectionIsVisible: Bool
    var seriesSectionIsVisible: Bool
   
    public init(
      destination: Destination.State? = nil,
      detailsState: DetailsFeature.State = .init(),
      movies: [MediaProjection] = [],
      series: [MediaProjection] = [],
      centerTextVisible: Bool = true,
      moviesSectionIsVisible: Bool = false,
      seriesSectionIsVisible: Bool = false
    ) {
      self.destination = destination
      self.detailsState = detailsState
      self.movies = movies
      self.series = series
      self.centerTextVisible = centerTextVisible
      self.moviesSectionIsVisible = moviesSectionIsVisible
      self.seriesSectionIsVisible = seriesSectionIsVisible
    }
  }
  
  public enum Action {
    case bookmarkSelected(Int, String)
    case deleteButtonTapped(Int)
    case deleteMediaResult(Result<Void, Error>)
    case destination(PresentationAction<Destination.Action>)
    case details(DetailsFeature.Action)
    case fetchBookmarksResult(Result<[MediaProjection], Error>)
    case onAppear
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.detailsState, action: \.details) {
      DetailsFeature()
    }
    Reduce { state, action in
      switch action {
      case .bookmarkSelected(let id, let mediaType):
        guard let media = MediaType(rawValue: mediaType) else { return .none }
        state.destination = .details(.init(id: id, mediaType: media))
        return .none
      case .deleteButtonTapped(let id):
        return deleteMedia(with: id)
      case .deleteMediaResult(.success):
        return fetchBookmarks()
      case .deleteMediaResult(.failure):
        return .none
      case .fetchBookmarksResult(.success(let results)):
        state.movies = results.filter { $0.mediaType == "movie" }
        state.series = results.filter { $0.mediaType == "tv" }
        state.moviesSectionIsVisible = !state.movies.isEmpty
        state.seriesSectionIsVisible = !state.series.isEmpty
        state.centerTextVisible = results.isEmpty
        return .none
      case .fetchBookmarksResult(.failure):
        state.centerTextVisible = true
        return .none
      case .onAppear:
        return fetchBookmarks()
      case .destination,
          .details:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
  
  private func deleteMedia(with id: Int) -> Effect<Self.Action> {
    .run { [id, client] send in
      await send(
        .deleteMediaResult(
          Result {
            try await client.deleteMedia(id)
          }
        )
      )
    }
  }
  
  private func fetchBookmarks() -> Effect<Self.Action> {
    .run { [client] send in
      await send(
        .fetchBookmarksResult(
          Result {
            try await client.fetchBookmarkedMedias()
          }
        )
      )
    }
  }
}
