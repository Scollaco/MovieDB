import Foundation
import SwiftUI
import WebKit

public struct VideoPlayerView: UIViewRepresentable {
  private let videoUrl: URL
  
  public init(videoUrl: URL) {
    self.videoUrl = videoUrl
  }
  
  public func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  public func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.scrollView.isScrollEnabled = false
    uiView.load(.init(url: videoUrl))
  }
}
