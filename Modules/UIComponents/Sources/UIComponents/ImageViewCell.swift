import Foundation
import SwiftUI

public struct ImageViewCell: View {
  private let imageUrl: String
  private var title: String
  private let date: String?
  private let rating: Double?
  private let placeholder: String
  
  public init(
    imageUrl: String,
    title: String,
    date: String? = nil,
    rating: Double? = nil,
    placeholder: String = "photo"
  ) {
    self.imageUrl = imageUrl
    self.title = title
    self.date = date
    self.rating = rating
    self.placeholder = placeholder
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
        if let url = URL(string: imageUrl) {
          CacheAsyncImage(url: url) { phase in
            switch phase {
            case .failure:
              Image(systemName: placeholder)
            case .success(let image):
              image.resizable()
            default:
              ProgressView()
            }
          }
          .frame(height: 165)
          .clipShape(RoundedRectangle(cornerRadius: 5))
        } else {
          Image(systemName: placeholder)
            .frame(height: 165)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        
        Text(title)
          .tint(.primary)
          .font(.footnote)
          .lineLimit(1)
          .bold()

        if let rating = rating {
          HStack(spacing: 0) {
            Image(systemName: "star.fill")
              .foregroundColor(.yellow)
              .imageScale(.small)
            Text("\(rating, specifier: "%.1f")")
              .font(.caption2)
              .foregroundStyle(.gray)
          }
        }
        
        if let date = date {
          Text(date)
            .font(.caption2)
            .foregroundStyle(.gray)
        }
      }
    .frame(width: 110)
  }
}
