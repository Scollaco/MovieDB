import ComposableArchitecture
import UIComponents
import SwiftUI

struct ReviewsMainView: View {
  var store: StoreOf<ReviewsFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List(viewStore.reviews, id: \.id) { review in
        ReviewCell(review: review)
      }
      .onAppear {
        viewStore.send(
          .requestReviews(
            id: viewStore.id,
            mediaType: viewStore.mediaType
          )
        )
      }
    }
  }
}

struct ReviewCell: View {
  var review: Review
  private let placeholder = "person.crop.circle.fill"
  
  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        HStack {
          if let imageUrl = review.authorDetails?.imageUrl,
             let url = URL(string: imageUrl) {
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
            .frame(width: 20, height: 20)
            .clipShape(Circle())
          } else {
            Image(systemName: placeholder)
              .frame(height: 30)
              .clipShape(Circle())
          }
          Text(review.authorDetails?.username ?? review.authorDetails?.name ?? "user")
            .font(.caption2)
            .bold()
        }
        Spacer()
        if let rating = review.authorDetails?.rating {
          HStack {
            Image(systemName: "star.fill")
              .frame(width: 15, height: 15)
              .foregroundColor(.yellow)
            Text("\(Int(rating))/10")
              .font(.caption)
              .bold()
          }
        }
      }
      
      ExpandableText(text: review.content ?? "", compactedLineLimit: 5)
        .tint(.primary)
        .font(.footnote)
     }
    .padding(.horizontal)
  }
}
