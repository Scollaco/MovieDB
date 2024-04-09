import UIComponents
import SwiftUI

struct ReviewsMainView: View {
  @ObservedObject var viewModel: ReviewsMainViewModel
  
  init(viewModel: ReviewsMainViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    List($viewModel.reviews, id: \.id) { review in
      ReviewCell(review: review)
      .onAppear {
        if viewModel.shouldLoadMoreData(review.wrappedValue.id) {
          viewModel.loadMoreData()
        }
      }
    }
    .onAppear {
      viewModel.fetchReviews()
    }
  }
}

struct ReviewCell: View {
  @Binding var review: Review
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
