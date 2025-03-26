import ComposableArchitecture
import Dependencies
import Foundation
import Details
import Reviews

@Reducer
public struct SeriesFeature {
  @Dependency(\.seriesClient) var client

  @Reducer
  public enum Destination {
    case details(DetailsFeature)
  }
  
  @ObservableState
  public struct State {
    @Presents var destination: Destination.State?
    
    var detailsState: DetailsFeature.State
    var isLoading: Bool
    var trendingSeries: [Series]
    var airingTodaySeries: [Series]
    var popularSeries: [Series]
    var topRatedSeries: [Series]
    var onTheAirSeries: [Series]
    
    var nextTrendingSeriesPage: Int
    var nextAiringTodayPage: Int
    var nextPopularPage: Int
    var nextTopRatedPage: Int
    var nextOnTheAirPage: Int
    
    init(
      destination: Destination.State? = nil,
      detailsState: DetailsFeature.State = .init(),
      isLoading: Bool = false,
      trendingSeries: [Series] = [],
      airingTodaySeries: [Series] = [],
      popularSeries: [Series] = [],
      topRatedSeries: [Series] = [],
      onTheAirSeries: [Series] = [],
      nextTrendingSeriesPage: Int = 1,
      nextAiringTodayPage: Int = 1,
      nextPopularPage: Int = 1,
      nextTopRatedPage: Int = 1,
      nextOnTheAirPage: Int = 1
    ) {
      self.destination = destination
      self.detailsState = detailsState
      self.isLoading = isLoading
      self.trendingSeries = trendingSeries
      self.airingTodaySeries = airingTodaySeries
      self.popularSeries = popularSeries
      self.onTheAirSeries = onTheAirSeries
      self.topRatedSeries = topRatedSeries
      self.nextTrendingSeriesPage = nextTrendingSeriesPage
      self.nextAiringTodayPage = nextAiringTodayPage
      self.nextPopularPage = nextPopularPage
      self.nextTopRatedPage = nextTopRatedPage
      self.nextOnTheAirPage = nextOnTheAirPage
    }
  }
  
  public enum Action {
    case cellDidAppear(Int, SeriesCategory)
    case destination(PresentationAction<Destination.Action>)
    case details(DetailsFeature.Action)
    case fetchSeriesResult(Result<SeriesResult, Error>)
    case fetchTrendingSeriesResult(Result<SeriesResult, Error>)
    case loadMoreData(SeriesCategory)
    case onAppear
    case seriesSelected(Int)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.detailsState, action: \.details) {
      DetailsFeature()
    }
    Reduce { state, action in
      switch action {
      case .cellDidAppear(let id, let category):
        let shouldLoadMoreData = shouldLoadMoreData(for: category, id: id, state: state)
        return shouldLoadMoreData ?
          .run { send in
            await send(.loadMoreData(category))
          } :
          .none
      case .onAppear:
        state.isLoading = true
        return .merge(
          // fetchTrendingSeries(page: state.nextTrendingPage),
          fetchSeries(category: .airingToday, page: state.nextAiringTodayPage),
          fetchSeries(category: .popular, page: state.nextPopularPage),
          fetchSeries(category: .topRated, page: state.nextTopRatedPage),
          fetchSeries(category: .onTheAir, page: state.nextOnTheAirPage)
        )
      case .fetchSeriesResult(.success(let result)):
        state.isLoading = false
        switch result.category {
        case .airingToday:
          state.nextAiringTodayPage += 1
          state.airingTodaySeries.append(contentsOf: result.series)
        case .popular:
          state.nextPopularPage += 1
          state.popularSeries.append(contentsOf: result.series)
        case .topRated:
          state.nextTopRatedPage += 1
          state.topRatedSeries.append(contentsOf: result.series)
        case .onTheAir:
          state.nextOnTheAirPage += 1
          state.onTheAirSeries.append(contentsOf: result.series)
        case .trending:
          break
        }
        return .none
      case .fetchSeriesResult(.failure(let error)):
        state.isLoading = false
        print("[SeriesFeature] \(error)")
        return .none
      case .fetchTrendingSeriesResult(.success(let result)):
        state.isLoading = false
        state.nextTrendingSeriesPage += 1
        state.trendingSeries.append(contentsOf: result.series)
        return .none
      case .fetchTrendingSeriesResult(.failure(let error)):
        state.isLoading = false
        print("[SeriesFeature - trending] \(error)")
        return .none
      case .loadMoreData(let category):
        switch category {
        case .airingToday:
          return fetchSeries(category: .airingToday, page: state.nextAiringTodayPage)
        case .popular:
          return fetchSeries(category: .popular, page: state.nextPopularPage)
        case .topRated:
          return fetchSeries(category: .topRated, page: state.nextTopRatedPage)
        case .onTheAir:
          return fetchSeries(category: .onTheAir, page: state.nextOnTheAirPage)
        case .trending:
          break
         // return fetchTrendingSeries(page: state.nextTrendingPage)
        }
        return .none
      case .seriesSelected(let id):
        state.destination = .details(.init(id: id, mediaType: .tv))
        return .none
      case .destination,
          .details:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
  
  private func fetchTrendingSeries(page: Int) -> Effect<Self.Action> {
    .run { [page, client] send in
      await send(
        .fetchTrendingSeriesResult(
          Result {
            let series = try await client.fetchTrendingSeries(page, .day)
              .results
              .shuffled()
            return .init(series: series, category: .trending)
          }
        )
      )
    }
  }
  
  private func fetchSeries(category: SeriesCategory, page: Int) -> Effect<Self.Action> {
    .run { [client, category, page] send in
      await send(
        .fetchSeriesResult(
          Result {
            let series = try await client.fetchSeries(category, page)
              .results
              .shuffled()
            return .init(series: series, category: category)
          }
        )
      )
    }
  }
  
  private func shouldLoadMoreData(for section: SeriesCategory, id: Int, state: State) -> Bool {
    let series = series(for: section, state: state)
    guard series.count > 10 else {
      return false
    }
    let targetItem = series[series.count - 3]
    return id == targetItem.id
  }
  
  private func series(for section: SeriesCategory, state: State) -> [Series] {
    switch section {
    case .airingToday:
      return state.airingTodaySeries
    case .onTheAir:
      return state.onTheAirSeries
    case .popular:
      return state.popularSeries
    case .topRated:
      return state.topRatedSeries
    case .trending:
      return state.trendingSeries
    }
  }
}

public struct SeriesResult {
  let series: [Series]
  let category: SeriesCategory
}
