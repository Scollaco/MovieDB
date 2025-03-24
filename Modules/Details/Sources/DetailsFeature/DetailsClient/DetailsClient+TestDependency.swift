import Dependencies

extension DetailsClient: TestDependencyKey {
  public static let testValue: Self = .mock
  public static let previewValue: Self = .mock
}

extension DependencyValues {
  public var detailsClient: DetailsClient {
    get { self[DetailsClient.self] }
    set { self[DetailsClient.self] = newValue }
  }
}

extension DetailsClient {
  public static let mock = Self()
}
