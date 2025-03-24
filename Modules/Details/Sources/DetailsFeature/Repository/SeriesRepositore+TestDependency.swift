import Dependencies

extension SeriesRepository: TestDependencyKey {
  public static let testValue: Self = .mock
  public static let previewValue: Self = .mock
}

extension DependencyValues {
  public var seriesRepository: SeriesRepository {
    get { self[SeriesRepository.self] }
    set { self[SeriesRepository.self] = newValue }
  }
}

extension SeriesRepository {
  public static let mock = Self()
}
