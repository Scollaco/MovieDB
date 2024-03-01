import Foundation

public enum Environment {
  enum Keys {
    static let authToken = "AUTH_TOKEN"
  }
  
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("plist file not found")
    }
    return dict
  }()
  
  static let authToken: String = {
    guard let token = Environment.infoDictionary[Keys.authToken] as? String else {
      fatalError("Token not found on plist")
    }
    return token
  }()
}
