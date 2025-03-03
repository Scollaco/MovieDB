import Dependencies
import Networking

extension MoviesClient: DependencyKey {
  public static let liveValue: Self = .live(network: NetworkImpl())
}

extension MoviesClient {
  public static func live(network: NetworkImpl) -> Self {
    return .init(
      fetchMovies: { section, page in
        try await network.requestTry(
          endpoint: MovieEndpoint(category: section, page: page),
          type: MovieResponse.self
        )
      },
      fetchTrendingMovies: { page, timeWindow in
        try await network.requestTry(
          endpoint: TrendingEndpoint(page: page, timeWindow: timeWindow),
          type: MovieResponse.self
        )
      }
    )
  }
}

/*
 func fetchMovies(
   section: MovieSection,
   page: Int = 1
 ) async throws -> MovieResponse {
   let result = await dependencies.network.request(
     endpoint: MovieEndpoint(category: section, page: page),
     type: MovieResponse.self
   )
   switch result {
   case .success(let response):
     return response
   case .failure(let error):
     throw(error)
   }
 }
 
 func fetchTrendingMovies(
   page: Int = 1,
   timeWindow: TimeWindow = .week
 ) async throws -> MovieResponse {
   let result = await dependencies.network.request(
     endpoint: TrendingEndpoint(page: page, timeWindow: timeWindow),
     type: MovieResponse.self
   )
   switch result {
   case .success(let response):
     return response
   case .failure(let error):
     throw(error)
   }
 }
}

 */
