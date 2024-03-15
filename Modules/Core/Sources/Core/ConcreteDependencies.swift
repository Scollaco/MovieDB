import Foundation
import Dependencies

public final class ConcreteDependencies: Dependencies {
  public var network: NetworkInterface
  
  
  public init(
    network: NetworkInterface
  ) {
    self.network = network
  }
}

