import Dependencies


protocol Service {
  func fetchNowPlayingMovies() async throws -> MovieResponse
}

final class MoviesService: Service {
  enum Category: String {
    case nowPlaying = "now_playing"
    case popular
    case topRated = "top_rated"
    case upcoming
  }
  
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func fetchNowPlayingMovies() async throws -> MovieResponse {
    let result = await dependencies.network.request(
      endpoint: MovieEndpoint(category: .nowPlaying),
      type: MovieResponse.self
    )
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw(error)
    }
  }
  
  func fetchPopularMovies() async throws -> MovieResponse {
    let result = await dependencies.network.request(
      endpoint: MovieEndpoint(category: .popular),
      type: MovieResponse.self
    )
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw(error)
    }
  }
  
  func fetchTopRatedMovies() async throws -> MovieResponse {
    let result = await dependencies.network.request(
      endpoint: MovieEndpoint(category: .topRated),
      type: MovieResponse.self
    )
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw(error)
    }
  }
  func fetchUpcomingMovies() async throws -> MovieResponse {
    let result = await dependencies.network.request(
      endpoint: MovieEndpoint(category: .upcoming),
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

fileprivate struct MovieEndpoint: Endpoint {
  var path: String = "/3/movie/"
  var additionalHeaders: [String : String]? = nil
  var method: HTTPMethod {
    .get([])
  }
  init(category: MoviesService.Category) {
    self.path.append(category.rawValue)
  }
}
