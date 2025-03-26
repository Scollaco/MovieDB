import ComposableArchitecture
import Dependencies
import Foundation
import Reviews

public enum Icon: String {
  case bookmark = "bookmark.circle"
  case bookmarkFill = "bookmark.circle.fill"
}

public enum MediaType: String {
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
    case destination(PresentationAction<Destination.Action>)
    case details(DetailsFeature.Action)
    case fetchMoviesDetailsResult(Result<MovieDetails, Error>)
    case fetchSeriesDetailsResult(Result<SeriesDetails, Error>)
    case onAppear(MediaType, Int)
    case onSelectingItem(MediaType, Int)
    case reviews(ReviewsFeature.Action)
    case reviewsButtonTapped
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .bookmarkButtonTapped:
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
        return mediaType == .movie ? fetchMovieDetails(id: id) : fetchSeriesDetails(id: id)
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
  
//  private func addToWatchlist(id: Int, isWatchlisted: Bool) -> Effect<Self.Action> {
//    .run { [id, isWatchlisted] in
//      
//    }
//    guard let series = seriesDetails else { return }
//    guard !isWatchlisted else {
//      _ = repository.delete(series: series)
//      watchlistIconName = Icon.bookmark.rawValue
//      return
//    }
//    _ = repository.create(series: series)
//    watchlistIconName = Icon.bookmarkFill.rawValue
//  }
  
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
  
//  private var isWatchlisted: Bool {
//    guard let seriesDetails = seriesDetails,
//          let _ = repository.getSeries(with: seriesDetails.id) else {
//      return false
//    }
//    return true
//  }
}

/*
 func addToWatchlist() {
   guard let series = seriesDetails else { return }
   guard !isWatchlisted else {
     _ = repository.delete(series: series)
     watchlistIconName = Icon.bookmark.rawValue
     return
   }
   _ = repository.create(series: series)
   watchlistIconName = Icon.bookmarkFill.rawValue
 }
 
 var shareDetails: String {
   let name = seriesDetails?.name ?? ""
   guard !providers.isEmpty else {
     return "\n\n\(name)"
   }
   return "\n\n\(name)\n\nAvailable on: \(providers.map(\.providerName).joined(separator: ", "))"
 }
 
 private var isWatchlisted: Bool {
   guard let seriesDetails = seriesDetails,
         let _ = repository.getSeries(with: seriesDetails.id) else {
     return false
   }
   return true
 }
 */
