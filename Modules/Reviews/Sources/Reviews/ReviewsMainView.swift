import ComposableArchitecture
import UIComponents
import SwiftUI

public struct ReviewsMainView: View {
  var store: StoreOf<ReviewsFeature>
  
  public init(store: StoreOf<ReviewsFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ScrollView {
      VStack {
        ForEach(store.reviews, id: \.id) { review in
          ReviewCell(review: review)
            .onAppear {
              if store.shouldLoadMoreData {
                store.send(
                  .requestReviews(
                    id: store.id,
                    mediaType: store.mediaType
                  )
                )
              }
            }
        }
      }
      .onAppear {
        store.send(
          .requestReviews(
            id: store.id,
            mediaType: store.mediaType
          )
        )
      }
    }
    .padding(.top, 10)
  }
}

struct ReviewCell: View {
  var review: Review
  private let placeholder = "person.crop.circle.fill"
  
  public var body: some View {
    VStack(alignment: .leading) {
      Divider()
        .background(.tertiary)

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
      .padding(.bottom, 15)
      
      ExpandableText(text: review.content ?? "", compactedLineLimit: 5)
        .tint(.primary)
        .font(.footnote)
    }
    .padding(.horizontal)
  }
}

#Preview {
  ReviewsMainView(
    store: .init(initialState: ReviewsFeature.State(
      reviews: [.mock()]
    )
  ) {
      ReviewsFeature()
    }
  )
}
