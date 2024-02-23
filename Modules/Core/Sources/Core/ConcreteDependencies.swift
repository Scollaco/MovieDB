import Foundation
import Dependencies

public final class ConcreteDependencies: ObservableObject, Dependencies {
  public let imageProvider: ImageProviderInterface
  public let network: NetworkInterface
  
  public init(
    network: NetworkInterface,
    imageProvider: ImageProviderInterface
  ) {
    self.network = network
    self.imageProvider = imageProvider
  }
}
