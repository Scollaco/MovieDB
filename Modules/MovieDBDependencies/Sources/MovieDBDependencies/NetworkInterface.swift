import Foundation

public protocol Endpoint {
  var additionalHeaders: [String: String]? { get }
  var path: String { get }
  var method: HTTPMethod { get }
}

public enum HTTPMethod: Equatable {
  case get([URLQueryItem])
  case post(Data)
  
  public var name: String {
    switch self {
    case .get: return "GET"
    case .post: return "POST"
    }
  }
}

public protocol NetworkInterface {
  func request<T: Decodable>(endpoint: Endpoint, type: T.Type) async -> Result<T, Error>
  func requestTry<T: Decodable>(endpoint: Endpoint, type: T.Type) async throws -> T
}
