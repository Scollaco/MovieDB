import UIKit

public protocol ImageProviderInterface {
  func fetchImage(for url: String) async -> UIImage?
}
