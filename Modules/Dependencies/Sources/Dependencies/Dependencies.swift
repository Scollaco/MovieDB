import Foundation

public protocol Dependencies {
  var network: NetworkInterface { get set }
  var imageProvider: ImageProviderInterface { get set }
}
