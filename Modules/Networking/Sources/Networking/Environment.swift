import Foundation

public enum Environment {
  enum Keys {
    static let apiKey = "API_KEY"
  }
  
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("plist file not found")
    }
    return dict
  }()
  
  static let apiKey: String = {
    guard let token = Environment.infoDictionary[Keys.apiKey] as? String else {
      fatalError("Token not found on plist")
    }
    return token
  }()
}
