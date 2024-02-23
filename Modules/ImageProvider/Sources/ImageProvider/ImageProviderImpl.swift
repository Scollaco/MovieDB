import Dependencies
import UIKit

public final class ImageProviderImpl: ImageProviderInterface {
  private let cache = NSCache<NSString, UIImage>()
  private var isDownloading = false
  
  public init() {}

  public func fetchImage(for url: String) async -> UIImage?  {
    let key = url as NSString
    if let image = cache.object(forKey: key) {
      return image
    }
    
    guard let url = URL(string: url) else {
      return nil
    }
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let image = UIImage(data: data) {
          cache.setObject(image, forKey: key)
          return image
        }
      } catch {
          return nil
      }
    return nil
  }
}
