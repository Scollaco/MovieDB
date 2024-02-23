import Foundation

public protocol Dependencies {
  var network: NetworkInterface { get }
  var imageProvider: ImageProviderInterface { get }
}
