import Dependencies

extension MoviesClient: TestDependencyKey {
  public static let testValue: Self = .mock
  public static let previewValue: Self = .mock
}

extension DependencyValues {
  public var moviesClient: MoviesClient {
    get { self[MoviesClient.self] }
    set { self[MoviesClient.self] = newValue }
  }
}

extension MoviesClient {
  public static let mock = Self()
}
