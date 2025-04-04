import SwiftUI

struct HideViewModifier: ViewModifier {
  let isHidden: Bool
  
  func body(content: Content) -> some View {
    if isHidden {
      EmptyView()
    } else {
      content
    }
  }
}

public extension View {
  func hide(if isHidden: Bool) -> some View {
    ModifiedContent(content: self, modifier: HideViewModifier(isHidden: isHidden))
  }
}
