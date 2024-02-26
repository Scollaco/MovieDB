import Foundation
import Dependencies

public final class ConcreteDependencies: Dependencies {
  public var imageProvider: ImageProviderInterface
  public var network: NetworkInterface
  public var router: RouterInterface
  
  public init(
    network: NetworkInterface,
    imageProvider: ImageProviderInterface,
    router: RouterInterface
  ) {
    self.network = network
    self.imageProvider = imageProvider
    self.router = router
  }
}

