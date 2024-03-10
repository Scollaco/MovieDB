import SwiftUI

public struct ProviderCell: View {
  private var url: String
  
  public init(url: String) {
    self.url = url
  }
  
  public var body: some View {
    if let url = URL(string: url) {
      CacheAsyncImage(url: url) { phase in
        switch phase {
        case .failure:
          Image(systemName: "photo") .font(.largeTitle)
        case .success(let image):
          image.resizable()
        default:
          ProgressView()
        }
      }
      .frame(width: 40, height: 40)
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
  }
}
