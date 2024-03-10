import Foundation
import Dependencies
import SwiftUI

public final class NetworkImpl: NetworkInterface, ObservableObject {
  private let session: URLSession = URLSession.shared
  private let decoder: JSONDecoder
  private let authToken: String = Environment.authToken
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
      "Authorization": authToken,
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
  public func request<T>(endpoint: Endpoint, type: T.Type) async -> Result<T, Error> where T: Decodable {
    guard let request = buildRequest(endpoint: endpoint) else {
      return .failure(RestAPIClientError.invalidUrl)
    }
    do {
      let (data, _) = try await session.data(for: request)
      let decoded = try decoder.decode(T.self, from: data)
      return .success(decoded)
    } catch {
      return .failure(error)
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
