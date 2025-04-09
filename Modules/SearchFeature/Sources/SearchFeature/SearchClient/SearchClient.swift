import DependenciesMacros

@DependencyClient
public struct SearchClient: Sendable {
  public var search: @Sendable (String, Int) async throws -> SearchResultResponse
}
