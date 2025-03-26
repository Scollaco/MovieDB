import Dependencies

extension SeriesClient: TestDependencyKey {
  public static let testValue: Self = .mock
  public static let previewValue: Self = .mock
}

extension DependencyValues {
  public var seriesClient: SeriesClient {
    get { self[SeriesClient.self] }
    set { self[SeriesClient.self] = newValue }
  }
}

extension SeriesClient {
  public static let mock = Self()
}
