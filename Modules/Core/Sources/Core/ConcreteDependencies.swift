import Foundation
import MovieDBDependencies

public final class ConcreteDependencies: MovieDBDependencies {
  public var network: NetworkInterface
  
  
  public init(
    network: NetworkInterface
  ) {
    self.network = network
  }
}

