import ComposableArchitecture
import Dependencies
import Foundation
import Details

@Reducer
public struct MoviesFeature {
  @Dependency(\.moviesClient) var client

  @Reducer
  public enum Destination {
    case details(DetailsFeature)
  }
  
  @ObservableState
  public struct State {
    @Presents var destination: Destination.State?
  
    var detailsState: DetailsFeature.State
    var isLoading: Bool
    var trendingMovies: [Movie]
    var nowPlayingMovies: [Movie]
    var popularMovies: [Movie]
    var topRatedMovies: [Movie]
    var upcomingMovies: [Movie]
    var nextTrendingPage: Int
    var nextNowPlayingPage: Int
    var nextPopularPage: Int
    var nextTopRatedPage: Int
    var nextUpcomingPage: Int
    
    init(
      destination: Destination.State? = nil,
      detailsState: DetailsFeature.State = .init(),
      isLoading: Bool = false,
      trendingMovies: [Movie] = [],
      nowPlayingMovies: [Movie] = [],
      popularMovies: [Movie] = [],
      topRatedMovies: [Movie] = [],
      upcomingMovies: [Movie] = [],
      nextTrendingPage: Int = 1,
      nextNowPlayingPage: Int = 1,
      nextPopularPage: Int = 1,
      nextTopRatedPage: Int = 1,
      nextUpcomingPage: Int = 1
    ) {
      self.destination = destination
      self.detailsState = detailsState
      self.isLoading = isLoading
      self.trendingMovies = trendingMovies
      self.nowPlayingMovies = nowPlayingMovies
      self.popularMovies = popularMovies
      self.topRatedMovies = topRatedMovies
      self.upcomingMovies = upcomingMovies
      self.nextTrendingPage = nextTrendingPage
      self.nextNowPlayingPage = nextNowPlayingPage
      self.nextPopularPage = nextPopularPage
      self.nextTopRatedPage = nextTopRatedPage
      self.nextUpcomingPage = nextUpcomingPage
    }
  }
  
  public enum Action {
    case cellDidAppear(Int, MovieSection)
    case destination(PresentationAction<Destination.Action>)
    case details(DetailsFeature.Action)
    case fetchNowPlayingMoviesResult(Result<[Movie], Error>)
    case fetchPopularMoviesResult(Result<[Movie], Error>)
    case fetchTopRatedMoviesResult(Result<[Movie], Error>)
    case fetchTrendingMoviesResult(Result<[Movie], Error>)
    case fetchUpcomingMoviesResult(Result<[Movie], Error>)
    case loadMoreData(MovieSection)
    case onAppear
    case movieSelected(Int)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.detailsState, action: \.details) {
      DetailsFeature()
    }
    Reduce { state, action in
      switch action {
      case .cellDidAppear(let id, let section):
        let shouldLoadMoreData = shouldLoadMoreData(for: section, id: id, state: state)
        return shouldLoadMoreData ?
          .run { send in
            await send(.loadMoreData(section))
          } :
          .none
      case .onAppear:
        state.isLoading = true
        return .merge(
          fetchNowPlayingMovies(state: state),
          fetchPopularMovies(state: state),
          fetchTrendingMovies(state: state),
          fetchUpcomingMovies(state: state),
          fetchTopRatedMovies(state: state)
        )
      case .fetchNowPlayingMoviesResult(.success(let playing)):
        state.isLoading = false
        state.nextNowPlayingPage += 1
        state.nowPlayingMovies.append(contentsOf: playing)
        return .none
      case .fetchNowPlayingMoviesResult(.failure(let error)):
        state.isLoading = false
        print("[MoviewsFeature - now playing] \(error)")
        return .none
      case .fetchPopularMoviesResult(.success(let popular)):
        state.isLoading = false
        state.nextPopularPage += 1
        state.popularMovies.append(contentsOf: popular)
        return .none
      case .fetchPopularMoviesResult(.failure(let error)):
        state.isLoading = false
        print("[MoviewsFeature - popular] \(error)")
        return .none
      case .fetchTopRatedMoviesResult(.success(let topRated)):
        state.isLoading = false
        state.nextTopRatedPage += 1
        state.topRatedMovies.append(contentsOf: topRated)
        return .none
      case .fetchTopRatedMoviesResult(.failure(let error)):
        state.isLoading = false
        print("[MoviewsFeature - top rated] \(error)")
        return .none
      case .fetchTrendingMoviesResult(.success(let trending)):
        state.isLoading = false
        state.nextTrendingPage += 1
        state.trendingMovies.append(contentsOf: trending)
        return .none
      case .fetchTrendingMoviesResult(.failure(let error)):
        state.isLoading = false
        print("[MoviewsFeature - trending] \(error)")
        return .none
      case .fetchUpcomingMoviesResult(.success(let upcoming)):
        state.isLoading = false
        state.nextUpcomingPage += 1
        state.upcomingMovies.append(contentsOf: upcoming)
        return .none
      case .fetchUpcomingMoviesResult(.failure(let error)):
        state.isLoading = false
        print("[MoviewsFeature - upcoming] \(error)")
        return .none
      case .loadMoreData(let category):
        switch category {
        case .nowPlaying:
          return fetchNowPlayingMovies(state: state)
        case .popular:
          return fetchPopularMovies(state: state)
        case .topRated:
          return fetchTopRatedMovies(state: state)
        case .upcoming:
          return fetchUpcomingMovies(state: state)
        case .trending:
          return fetchTrendingMovies(state: state)
        }
      case .movieSelected(let id):
        state.destination = .details(.init(id: id, mediaType: .movie))
        return .none
      case .destination,
          .details:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
  
  private func fetchTrendingMovies(state: State) -> Effect<Self.Action> {
    .run { [state, client] send in
      await send(
        .fetchTrendingMoviesResult(
          Result {
            return try await client.fetchTrendingMovies(state.nextTrendingPage, .week)
              .results
              .shuffled()
          }
        )
      )
    }
  }
  
  private func fetchPopularMovies(state: State) -> Effect<Self.Action> {
    .run { [state, client] send in
      await send(
        .fetchPopularMoviesResult(
          Result {
            return try await client.fetchMovies(.popular, state.nextPopularPage)
              .results
              .shuffled()
          }
        )
      )
    }
  }
  
  private func fetchNowPlayingMovies(state: State) -> Effect<Self.Action> {
    .run { [state, client] send in
      await send(
        .fetchNowPlayingMoviesResult(
          Result {
            return try await client.fetchMovies(.nowPlaying, state.nextNowPlayingPage)
              .results
              .shuffled()
          }
        )
      )
    }
  }
  
  private func fetchTopRatedMovies(state: State) -> Effect<Self.Action> {
    .run { [state, client] send in
      await send(
        .fetchTopRatedMoviesResult(
          Result {
            return try await client.fetchMovies(.topRated, state.nextTopRatedPage)
              .results
              .shuffled()
          }
        )
      )
    }
  }
  
  private func fetchUpcomingMovies(state: State) -> Effect<Self.Action> {
    .run { [state, client] send in
      await send(
        .fetchUpcomingMoviesResult(
          Result {
            return try await client.fetchMovies(.upcoming, state.nextUpcomingPage)
              .results
              .shuffled()
          }
        )
      )
    }
  }
  
  private func shouldLoadMoreData(for section: MovieSection, id: Int, state: State) -> Bool {
    let movies = movies(for: section, state: state)
    guard movies.count > 10 else {
      return false
    }
    let targetItem = movies[movies.count - 3]
    return id == targetItem.id
  }
  
  private func movies(for section: MovieSection, state: State) -> [Movie] {
    switch section {
    case .nowPlaying:
      return state.nowPlayingMovies
    case .popular:
      return state.popularMovies
    case .topRated:
      return state.topRatedMovies
    case .trending:
      return state.trendingMovies
    case .upcoming:
      return state.upcomingMovies
    }
  }
}
