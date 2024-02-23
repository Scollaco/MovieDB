import SwiftUI

enum CollectionLoadingState<Content> {
  case empty
  case error(Error)
  case loading(placeholder: Content)
  case loaded(content: Content)
}

struct CollectionLoadingView<Item, Content: View, EmptyView: View, ErrorView: View>: View {
  private let fade = AnyTransition.opacity.animation(Animation.linear(duration: 0.5))
  private let state: CollectionLoadingState<Item>
  private let makeContent: (Item) -> Content
  private let makeEmpty: () -> EmptyView
  private let makeError: (Error) -> ErrorView
  init(
    state: CollectionLoadingState<Item>,
    @ViewBuilder content: @escaping (Item) -> Content,
    @ViewBuilder empty: @escaping () -> EmptyView,
    @ViewBuilder error: @escaping (Error) -> ErrorView
  ) {
    self.state = state
    self.makeContent = content
    self.makeEmpty = empty
    self.makeError = error
  }
  
  var body: some View {
    switch state {
    case let .loading(placeholders):
      makeContent(placeholders)
        .redacted(reason: .placeholder)
        .shimmer()
        .disabled(true)
        .transition(fade)
    case let .loaded(items):
      makeContent(items)
        .transition(fade)
    case .empty:
      makeEmpty()
        .transition(fade)
    case let .error(error):
      makeError(error)
        .transition(fade)
    }
  }
}
