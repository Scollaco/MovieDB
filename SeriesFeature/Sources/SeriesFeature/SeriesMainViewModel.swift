import Foundation
import Utilities

public final class SeriesMainViewModel: ObservableObject {
  private let service: Service

  @Published var airingTodaySeries: [Series] = []
  @Published var popularSeries: [Series] = []
  @Published var topRatedSeries: [Series] = []
  @Published var onTheAirSeries: [Series] = []
  
  private(set) var nextAiringTodayPage = 1
  private(set) var nextPopularPage = 1
  private(set) var nextTopRatedPage = 1
  private(set) var nextOnTheAirPage = 1
  
  public init(service: Service) {
    self.service = service
    fetchMovies()
  }
  
  func fetchMovies() {
    Task {
      do {
        try await fetchAiringTodaySeries()
        try await fetchPopularSeries()
        try await fetchTopRatedSeries()
        try await fetchOnTheAirSeries()
      } catch {
        print(error)
      }
    }
  }
  
  @MainActor
  private func fetchAiringTodaySeries() async throws {
    let popularResponse = try await service.fetchSeries(category: .airingToday, page: nextAiringTodayPage)
    nextAiringTodayPage = popularResponse.page + 1
    let movies = popularResponse
      .results
      .sorted(by: { $0.popularity > $1.popularity})
    airingTodaySeries.append(contentsOf: movies)
  }
  
  @MainActor
  private func fetchPopularSeries() async throws {
    let nowPlayingResponse = try await service.fetchSeries(category: .popular, page: nextPopularPage)
    nextPopularPage = nowPlayingResponse.page + 1
    let movies = nowPlayingResponse
      .results
    popularSeries.append(contentsOf: movies)
  }
  
  @MainActor
  private func fetchTopRatedSeries() async throws {
    let topRatedResponse = try await service.fetchSeries(category: .topRated, page: nextTopRatedPage)
    nextTopRatedPage = topRatedResponse.page + 1
    let movies = topRatedResponse
      .results
      .sorted(by: { $0.voteAverage > $1.voteAverage })
    topRatedSeries.append(contentsOf: movies)
  }
  
  @MainActor
  private func fetchOnTheAirSeries() async throws {
    let onTheAirResponse = try await service.fetchSeries(category: .onTheAir, page: nextOnTheAirPage)
    nextOnTheAirPage = onTheAirResponse.page + 1
    let movies = onTheAirResponse
      .results
      .sorted(by: { $0.popularity > $1.popularity })
    if let last = movies.last {
      onTheAirSeries.append(contentsOf: [last])
    }
  }
  
  func shouldLoadMoreData(_ movieId: Int, items: [Series]) -> Bool {
    // Fetch more data when list is approaching the end
    let targetItem = items.count >= 6 ? items[items.count - 5] : items.last
    return movieId == targetItem?.id
  }
  
  func loadMoreData(for category: Category) {
    Task { @MainActor in
      switch category {
      case .airingToday:
        try? await fetchAiringTodaySeries()
      case .popular:
        try? await fetchPopularSeries()
      case .topRated:
        try? await fetchTopRatedSeries()
      case .onTheAir:
        try? await fetchOnTheAirSeries()
      }
    }
  }
}
