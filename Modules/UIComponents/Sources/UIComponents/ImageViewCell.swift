import Foundation
import SwiftUI

public struct ImageViewCell: View {
  private let imageUrl: String
  private var title: String
  private let date: String?
  private let placeholder: String
  
  public init(
    imageUrl: String,
    title: String,
    date: String? = nil,
    placeholder: String = "photo"
  ) {
    self.imageUrl = imageUrl
    self.title = title
    self.date = date
    self.placeholder = placeholder
  }
  
  public var body: some View {
    VStack {
      if let url = URL(string: imageUrl) {
        CacheAsyncImage(url: url) { phase in
          switch phase {
          case .failure:
            Image(systemName: placeholder) .font(.largeTitle)
          case .success(let image):
            image.resizable()
          default:
            ProgressView()
          }
        }
        .frame(height: 165)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      
      Text(title)
        .font(.footnote)
        .lineLimit(1)
        .bold()
      
      if let date = date {
        Text(date)
          .font(.caption2)
          .foregroundStyle(.gray)
      }
     }
    .frame(width: 110)
  }
}
