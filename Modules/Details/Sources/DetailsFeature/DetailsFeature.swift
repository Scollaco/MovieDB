import ComposableArchitecture
import Dependencies
import Foundation
import Reviews

public enum Icon: String {
  case bookmark = "bookmark.circle"
  case bookmarkFill = "bookmark.circle.fill"
}

public enum MediaType: String, Sendable {
  case movie
  case tv
}

@Reducer
public struct DetailsFeature {
  @Dependency(\.detailsClient) var client
  
  @Reducer
  public indirect enum Destination {
    case details(DetailsFeature)
    case reviews(ReviewsFeature)
  }
  
  @ObservableState
  public struct State {
    @Presents var destination: Destination.State?
    
    var id: Int
    var mediaType: MediaType
    var movieDetails: MovieDetails?
    var seriesDetails: SeriesDetails?
    var seasons: [SeriesDetails.Season]
    var videos: [Video]
    var providers: [WatchProvider]
    var watchlistIconName: String
    var reviewsSectionIsVisible: Bool
    var overviewIsVisible: Bool
    var genreListIsVisible: Bool
    var directorsRowIsVisible: Bool
    var isWatchlisted: Bool
  
    public init(
      destination: Destination.State? = nil,
      id: Int = 0,
      mediaType: MediaType = .movie,
      movieDetails: MovieDetails? = nil,
      seriesDetails: SeriesDetails? = nil,
      seasons: [SeriesDetails.Season] = [],
      videos: [Video] = [],
      providers: [WatchProvider] = [],
      watchlistIconName: String = Icon.bookmark.rawValue,
      reviewsSectionIsVisible: Bool = false,
      overviewIsVisible: Bool = false,
      genreListIsVisible: Bool = false,
      directorsRowIsVisible: Bool = false,
      isWatchlisted: Bool = false
    ) {
      self.destination = destination
      self.id = id
      self.mediaType = mediaType
      self.movieDetails = movieDetails
      self.seriesDetails = seriesDetails
      self.seasons = seasons
      self.videos = videos
      self.providers = providers
      self.watchlistIconName = watchlistIconName
      self.reviewsSectionIsVisible = reviewsSectionIsVisible
      self.overviewIsVisible = overviewIsVisible
      self.genreListIsVisible = genreListIsVisible
      self.directorsRowIsVisible = directorsRowIsVisible
      self.isWatchlisted = isWatchlisted
    }
  }
  
  public indirect enum Action: BindableAction {
    case binding(BindingAction<State>)
    case bookmarkButtonTapped
    case bookmarkMediaResult(Result<String, Error>)
    case destination(PresentationAction<Destination.Action>)
    case details(DetailsFeature.Action)
    case fetchMoviesDetailsResult(Result<MovieDetails, Error>)
    case fetchSeriesDetailsResult(Result<SeriesDetails, Error>)
    case onAppear(MediaType, Int)
    case onSelectingItem(MediaType, Int)
    case refreshBookmarkIconResult(Result<String, Error>)
    case reviews(ReviewsFeature.Action)
    case reviewsButtonTapped
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .bookmarkButtonTapped:
        let media = MediaProjection(
          id: state.id,
          backdropPath: state.mediaType == .movie ? state.movieDetails?.backdropPath : state.seriesDetails?.backdropPath,
          posterPath: state.mediaType == .movie ? state.movieDetails?.posterPath : state.seriesDetails?.posterPath,
          originalTitle: (state.mediaType == .movie ? state.movieDetails?.originalTitle : state.seriesDetails?.originalName) ?? "",
          overview: (state.mediaType == .movie ? state.movieDetails?.overview : state.seriesDetails?.overview) ?? "",
          mediaType: state.mediaType.rawValue,
          title: (state.mediaType == .movie ? state.movieDetails?.title : state.seriesDetails?.name) ?? ""
        )
        return bookmark(media: media)
      case .bookmarkMediaResult(.success(let iconName)):
        state.watchlistIconName = iconName
        return .none
      case .bookmarkMediaResult(.failure):
        return .none
      case .fetchMoviesDetailsResult(.success(let details)):
        state.movieDetails = details
        state.videos = details.videos.results
          .filter { $0.videoType == .trailer || $0.videoType == .behindScenes }
        state.reviewsSectionIsVisible = !(details.reviews?.isEmpty ?? true)
        state.overviewIsVisible = !details.overview.isEmpty
        state.genreListIsVisible = !(details.genres?.isEmpty ?? true)
        state.directorsRowIsVisible = !(details.createdBy?.isEmpty ?? true)
        state.providers = generateProviders(for: details.watchProviders)
        return .none
      case .fetchMoviesDetailsResult(.failure(let error)):
        print("[Movies Details] Error: \(error)")
        return .none
      case .fetchSeriesDetailsResult(.success(let details)):
        state.seriesDetails = details
        state.seasons = details.seasons
        state.videos = details.videos?.results ?? []
          .filter { $0.videoType == .trailer || $0.videoType == .behindScenes }
        state.reviewsSectionIsVisible = !(details.reviews?.isEmpty ?? true)
        state.overviewIsVisible = !details.overview.isEmpty
        state.genreListIsVisible = !(details.genres?.isEmpty ?? true)
        state.directorsRowIsVisible = !(details.createdBy?.isEmpty ?? true)
        state.providers = generateProviders(for: details.watchProviders)
        return .none
      case .fetchSeriesDetailsResult(.failure(let error)):
        print("[Series Details] Error: \(error)")
        return .none
      case .onAppear(let mediaType, let id):
        state.id = id
        state.mediaType = mediaType
        return .merge(
          mediaType == .movie ? fetchMovieDetails(id: id) : fetchSeriesDetails(id: id),
          getIconName(for: id)
        )
      case .onSelectingItem(let mediaType, let id):
        state.destination = .details(.init(id: id, mediaType: mediaType))
        return .none
      case .reviewsButtonTapped:
        state.destination = .reviews(.init(id: state.id, mediaType: state.mediaType.rawValue))
        return .none
      case .binding,
          .destination,
          .details,
          .reviews:
        return .none
      case .refreshBookmarkIconResult(.success(let iconName)):
        state.watchlistIconName = iconName
        return .none
      case .refreshBookmarkIconResult(.failure):
        state.watchlistIconName = Icon.bookmark.rawValue
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
  
  private func fetchMovieDetails(id: Int) -> Effect<Self.Action> {
    .run { [id, client] send in
      await send(
        .fetchMoviesDetailsResult(
          Result {
            try await client.fetchMovieDetails(id)
          }
        )
      )
    }
  }
  
  private func fetchSeriesDetails(id: Int) -> Effect<Self.Action> {
    .run { [id, client] send in
      await send(
        .fetchSeriesDetailsResult(
          Result {
            try await client.fetchSeriesDetails(id)
          }
        )
      )
    }
  }
  
  private func bookmark(media: MediaProjection) -> Effect<Self.Action> {
    .run { [media, client] send in
      await send(
        .bookmarkMediaResult(
          Result {
            if let media = try await client.fetchMedia(media.id) {
              try await client.deleteMedia(media.id)
              return  "bookmark.circle"
            }
            try await client.saveMedia(media)
            return "bookmark.circle.fill"
          }
        )
      )
    }
  }
  
  private func getIconName(for id: Int) -> Effect<Self.Action> {
    .run { [client] send in
      await send(
        .bookmarkMediaResult(
          Result {
            if let _ = try await client.fetchMedia(id) {
              return "bookmark.circle.fill"
            }
            return "bookmark.circle"
          }
        )
      )
    }
  }
  
  private func generateProviders(for response: WatchProviderResponse?) -> [WatchProvider] {
    let buy = response?.results.US?.buy ?? []
    let flatrate = response?.results.US?.flatrate ?? []
    let rent = response?.results.US?.rent ?? []
    return Array(Set(buy + flatrate + rent)).sorted(by: { $0.displayPriority < $1.displayPriority } )
  }
  
//  var shareDetails: String {
//    let name = seriesDetails?.name ?? ""
//    guard !providers.isEmpty else {
//      return "\n\n\(name)"
//    }
//    return "\n\n\(name)\n\nAvailable on: \(providers.map(\.providerName).joined(separator: ", "))"
//  }

}
