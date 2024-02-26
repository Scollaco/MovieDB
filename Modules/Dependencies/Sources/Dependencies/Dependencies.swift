import Foundation

public protocol Dependencies {
  var network: NetworkInterface { get set }
  var imageProvider: ImageProviderInterface { get set }
  var router: RouterInterface { get set }
}

public protocol StandardRouteResponder: RouteRequestResponder {
    init(interfaces: Dependencies)
}
