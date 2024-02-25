import Foundation
import Dependencies

public final class ConcreteDependencies: Dependencies {
  public var imageProvider: ImageProviderInterface
  public var network: NetworkInterface
  
  public init(
    network: NetworkInterface,
    imageProvider: ImageProviderInterface
  ) {
    self.network = network
    self.imageProvider = imageProvider
  }
}

