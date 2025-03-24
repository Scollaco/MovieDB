import Dependencies

extension MovieRepository: TestDependencyKey {
  public static let testValue: Self = .mock
  public static let previewValue: Self = .mock
}

extension DependencyValues {
  public var movieRepository: MovieRepository {
    get { self[MovieRepository.self] }
    set { self[MovieRepository.self] = newValue }
  }
}

extension MovieRepository {
  public static let mock = Self()
}
