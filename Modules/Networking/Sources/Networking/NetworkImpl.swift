import Foundation
import MovieDBDependencies
import SwiftUI

public final class NetworkImpl: NetworkInterface, ObservableObject {
  private let session: URLSession = URLSession.shared
  private let decoder: JSONDecoder
  private let apiKey: String = Environment.apiKey
  private let host: String = "api.themoviedb.org"
  
  // MARK: - Init
  
  public init() {
    decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
  }
  
  // MARK: - Private
  
  private func buildRequest(endpoint: Endpoint) -> URLRequest? {
    let region = Locale.current.region?.identifier
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "api_key", value: apiKey),
      URLQueryItem(name: "region", value: region)
    ]
    switch endpoint.method {
    case .get(let parameters):
      queryItems.append(contentsOf: parameters)
    case .post: ()
    }
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = endpoint.path
    urlComponents.queryItems = queryItems
    
    guard let url = urlComponents.url else {
      print("failed to build url from components")
      assert(endpoint.path.hasPrefix("/"))
      return nil
    }
    
    var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
    var headers: [String: String] = [
      "Accept": "application/json",
      "Content-Type": "application/json"
    ]
    
    if let additionalHeaders = endpoint.additionalHeaders {
      additionalHeaders.forEach { key, value in
        headers[key] = value
      }
    }
    
    headers.forEach { key, value in
      urlRequest.addValue(value, forHTTPHeaderField: key)
    }
    urlRequest.httpMethod = endpoint.method.name
    
    switch endpoint.method {
    case .get: ()
    case .post(let data):
      urlRequest.httpBody = data
    }
    return urlRequest
  }
}

// MARK: - NetworkInterface

extension NetworkImpl {
  public func request<T: Decodable>(endpoint: Endpoint, type: T.Type) async -> Result<T, Error> {
    let request = buildRequest(endpoint: endpoint)
    guard let url = request?.url else {
      return .failure(RestAPIClientError.invalidUrl)
    }
    do {
      let (data, _) = try await session.data(from: url)
      let object = try decoder.decode(type.self, from: data)
      return .success(object)
    } catch {
      return .failure(error)
    }
  }
  
  public func requestTry<T: Decodable>(endpoint: Endpoint, type: T.Type) async throws -> T {
    let request = buildRequest(endpoint: endpoint)
    guard let url = request?.url else {
      throw RestAPIClientError.invalidUrl
    }
    do {
      let (data, _) = try await session.data(from: url)
      return try decoder.decode(type.self, from: data)
    }
  }
}

enum RestAPIClientError: Error {
  case invalidUrl
  case unknown
  var localizedDescription: String {
    switch self {
    case .invalidUrl:
      return "Invalid URL."
      
    case .unknown:
      return "Unknown API error."
    }
  }
}
