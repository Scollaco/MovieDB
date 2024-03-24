import SwiftUI

public protocol Coordinator {
  var path: NavigationPath { get set }
  func popToRoot()
  func dismiss()
}
