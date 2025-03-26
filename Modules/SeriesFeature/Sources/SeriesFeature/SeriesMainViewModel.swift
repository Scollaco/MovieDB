//import Foundation
//import Utilities
//
//final class SeriesMainViewModel: ObservableObject {
//  private let service: Service
//  
//  @Published var trendingSeries: [Series] = []
//  @Published var airingTodaySeries: [Series] = []
//  @Published var popularSeries: [Series] = []
//  @Published var topRatedSeries: [Series] = []
//  @Published var onTheAirSeries: [Series] = []
//  
//  private(set) var nextTrendingSeriesPage = 1
//  private(set) var nextAiringTodayPage = 1
//  private(set) var nextPopularPage = 1
//  private(set) var nextTopRatedPage = 1
//  private(set) var nextOnTheAirPage = 1
//  
//  init(service: Service) {
//    self.service = service
//    fetchSeries()
//  }
//  
//  func fetchSeries() {
//    Task {
//      do {
//        try await fetchTrendingSeries()
//        try await fetchAiringTodaySeries()
//        try await fetchPopularSeries()
//        try await fetchTopRatedSeries()
//        try await fetchOnTheAirSeries()
//      } catch {
//        print(error)
//      }
//    }
//  }
//  
//  @MainActor
//  private func fetchTrendingSeries() async throws {
//    let trendingResponse = try await service.fetchTrendingSeries(
//      page: nextTrendingSeriesPage,
//      timeWindow: .week
//    )
//    nextTrendingSeriesPage = trendingResponse.page + 1
//    let movies = trendingResponse
//      .results
//    trendingSeries.append(contentsOf: movies)
//  }
//  
//  @MainActor
//  private func fetchAiringTodaySeries() async throws {
//    let popularResponse = try await service.fetchSeries(category: .airingToday, page: nextAiringTodayPage)
//    nextAiringTodayPage = popularResponse.page + 1
//    let movies = popularResponse
//      .results
//      .shuffled()
//    airingTodaySeries.append(contentsOf: movies)
//  }
//  
//  @MainActor
//  private func fetchPopularSeries() async throws {
//    let nowPlayingResponse = try await service.fetchSeries(category: .popular, page: nextPopularPage)
//    nextPopularPage = nowPlayingResponse.page + 1
//    let series = nowPlayingResponse
//      .results
//      .shuffled()
//    popularSeries.append(contentsOf: series)
//  }
//  
//  @MainActor
//  private func fetchTopRatedSeries() async throws {
//    let topRatedResponse = try await service.fetchSeries(category: .topRated, page: nextTopRatedPage)
//    nextTopRatedPage = topRatedResponse.page + 1
//    let movies = topRatedResponse
//      .results
//      .shuffled()
//    topRatedSeries.append(contentsOf: movies)
//  }
//  
//  @MainActor
//  private func fetchOnTheAirSeries() async throws {
//    let onTheAirResponse = try await service.fetchSeries(category: .onTheAir, page: nextOnTheAirPage)
//    nextOnTheAirPage = onTheAirResponse.page + 1
//    let movies = onTheAirResponse
//      .results
//      .shuffled()
//    if let last = movies.last {
//      onTheAirSeries.append(contentsOf: [last])
//    }
//  }
//  
//  func shouldLoadMoreData(_ movieId: Int, items: [Series]) -> Bool {
//    guard items.count > 10 else { return false }
//    // Fetch more data when list is approaching the end
//    let targetItem = items[items.count - 5]
//    return movieId == targetItem.id
//  }
//  
//  func loadMoreData(for category: SeriesCategory) {
//    Task { @MainActor in
//      switch category {
//      case .trending:
//        try? await fetchTrendingSeries()
//      case .airingToday:
//        try? await fetchAiringTodaySeries()
//      case .popular:
//        try? await fetchPopularSeries()
//      case .topRated:
//        try? await fetchTopRatedSeries()
//      case .onTheAir:
//        try? await fetchOnTheAirSeries()
//      }
//    }
//  }
//}
