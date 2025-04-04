import Dependencies

extension MediaRepository: TestDependencyKey {
  public static let testValue: Self = .mock
  public static let previewValue: Self = .mock
}

extension DependencyValues {
  public var mediaRepository: MediaRepository {
    get { self[MediaRepository.self] }
    set { self[MediaRepository.self] = newValue }
  }
}

extension MediaRepository {
  public static let mock = Self()
}
