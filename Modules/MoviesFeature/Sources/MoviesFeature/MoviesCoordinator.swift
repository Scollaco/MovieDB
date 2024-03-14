import Dependencies
//import Routing
//import SwiftUI
//
//public struct NavigationController: UIViewControllerRepresentable {
//  public func updateUIViewController(_ navigationController: UIViewControllerType, context: Context) {}
//  public func makeUIViewController(context: Context) -> some UINavigationController {
//    UINavigationController()
//  }
//}
//
//public final class MoviesCoordinator: ObservableObject {
//  private let dependencies: Dependencies
//  private let navigationController = NavigationController()
//  
//  public init(dependencies: Dependencies) {
//    self.dependencies = dependencies
//    navigationController.makeUIViewController(context: Context)
//  }
//  
//  public var rootViewController: NavigationController {
//    let root = makeMainView() as! any ViewControllable
//   return  NavigationController(rootViewController: root.viewController)
//  }
//  
//  // MARK: - Navigation
//  
//  func popToRoot(holder: NavigationStackHolder) {
//    guard let viewController = holder.viewController else { return }
//    rootViewController.popToRootViewController(
//      animated: false
//    )
//  }
//  
//  func dismiss(holder: NavigationStackHolder) {
//    guard let viewController = holder.viewController else { return }
//    rootViewController.dismiss(animated: true)
//  }
//  
//  func pushDetailsView(id: Int, from viewController: UIViewController) {
//    guard let details = makeMovieDetailsView(id: id) as? any ViewControllable else { return }
//    rootViewController.pushViewController(
//      details.viewController,
//      animated: true
//    )
//  }
//  
//  @ViewBuilder
//  public func makeMainView() -> some View {
//    let service = MoviesService(dependencies: dependencies)
//    let viewModel = MoviesMainViewModel(service: service)
//    MoviesMainView(
//      viewModel: viewModel,
//      dependencies: dependencies,
//      coordinator: self
//    )
//  }
//  
//  @ViewBuilder
//  public func makeMovieDetailsView(id: Int) -> some View {
//    let service = MovieDetailsService(dependencies: dependencies)
//    let viewModel = MovieDetailsViewModel(id: id, service: service)
//    MovieDetailsView(viewModel: viewModel, dependencies: dependencies)
//  }
//}

import SwiftUI
import Routing

public final class MoviesCoordinator: Coordinator, ObservableObject {
  @Published public var path = NavigationPath()
  @Published var page: Page = .home
  let dependencies: Dependencies
  // MARK: - Navigation
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func popToRoot() {
    path.removeLast(path.count)
  }
  
  public func dismiss() {
    guard path.count > 0 else { return }
    path.removeLast()
  }
  
  func goToDetails(id: Int) {
    path.append(Page.details(id: id))
  }
  
  private lazy var mainView: some View = {
    let service = MoviesService(dependencies: dependencies)
    let viewModel = MoviesMainViewModel(service: service)
    return MoviesMainView(
      viewModel: viewModel,
      dependencies: dependencies,
      coordinator: self
    )
  }()
  
  // MARK: - View providers
  @ViewBuilder
  public func get(page: Page) -> some View {
    switch page {
    case .home:
      mainView
    case .details(let id):
      let service = MovieDetailsService(dependencies: dependencies)
      let viewModel = MovieDetailsViewModel(id: id, service: service)
      MovieDetailsView(
        viewModel: viewModel,
        dependencies: dependencies,
        coordinator: self
      )
    }
  }
}

public enum Page: Identifiable, Hashable {
  case home
  case details(id: Int)
  
  public var id: String {
    ID(describing: self)
  }
}
