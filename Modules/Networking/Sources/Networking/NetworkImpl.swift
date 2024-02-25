import Foundation
import Dependencies

public final class NetworkImpl: NetworkInterface {
    
    private let session: URLSession = URLSession.shared
    private let decoder: JSONDecoder
    private let authToken: String = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MTA4MDBiMzgxNGYzOTA5ODI1NzJiMWVjMTJmYWY3ZiIsInN1YiI6IjY1ZDc0N2IyOWFmMTcxMDE3YjU5M2VlMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.COx_GEjUYyU-N8eX16Ud_HcXQVb6l61s3LfkkP8fVyg"
    private let host: String = "api.themoviedb.org"

    // MARK: - Init

    public init() {
      decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // MARK: - Private

    private func buildRequest(endpoint: Endpoint) -> URLRequest? {
        var queryItems: [URLQueryItem] = []
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

        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
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

struct ServerAPIError: Error {
  let statusCode: Int
  let statusMessage: String
  let success: Bool
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
