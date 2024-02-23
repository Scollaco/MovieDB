import Foundation
import Dependencies

public final class NetworkImpl: NetworkInterface {
    
    private let session: URLSession = URLSession.shared
    private let decoder: JSONDecoder
    private let authToken: String = "710800b3814f390982572b1ec12faf7f"
    private let host: String = "host"

    // MARK: - Init

    public init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
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
  public func task<T>(endpoint: Endpoint, type: T.Type) async -> Result<T, Error> where T: Decodable {
    guard let request = buildRequest(endpoint: endpoint) else {
      return .failure(RestAPIClientError.invalidUrl)
    }
    do {
      let (data, response) = try await session.data(for: request)
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
