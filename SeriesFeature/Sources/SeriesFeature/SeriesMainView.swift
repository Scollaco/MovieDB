import Foundation
import Dependencies
import Utilities
import UIComponents
import SwiftUI
import CoreData

struct SeriesMainView: View {
  @ObservedObject private var viewModel: SeriesMainViewModel
  private var router: SeriesRouter
  
  init(viewModel: SeriesMainViewModel, router: SeriesRouter) {
    self.viewModel = viewModel
    self.router = router
  }
  public var body: some View {
    ScrollView(showsIndicators: false) {
      ListSection(
        title: "Airing today",
        category: .airingToday,
        viewModel: viewModel,
        router: router,
        items: $viewModel.airingTodaySeries.wrappedValue
      )
      .padding(.bottom)
      
      ListSection(
        title: "Top rated",
        category: .topRated,
        viewModel: viewModel,
        router: router,
        items: $viewModel.topRatedSeries.wrappedValue
      )
      .padding(.bottom)
      
      ListSection(
        title: "Popular",
        category: .popular,
        viewModel: viewModel,
        router: router,
        items: $viewModel.popularSeries.wrappedValue
      )
      
      ListSection(
        title: "On the air",
        category: .onTheAir,
        viewModel: viewModel,
        router: router,
        items: $viewModel.onTheAirSeries.wrappedValue
      )
      .padding(.bottom)
    }
    .listRowSpacing(10)
  }
}

struct ListSection: View {
  let title: String
  let category: Category
  let viewModel: SeriesMainViewModel
  let router: SeriesRouter
  let items: [Series]
  
  @State private var scrollPosition: CGFloat = .zero
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { series in
            ImageViewCell(
              imageUrl: series.imageUrl,
              title: series.name
            )
              .onAppear {
                if viewModel.shouldLoadMoreData(series.id, items: items) {
                  viewModel.loadMoreData(for: category)
                }
              }
              .onTapGesture {
                router.navigate(to: .details(series))
              }
          }
        }
      }
    } header: {
      Text(title)
        .font(.title2)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
  }
}

struct ImageView: View {
  @Binding var series: Series
  
  var body: some View {
    VStack {
      if let url = URL(string: series.imageUrl) {
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
        .frame(height: 165)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      
      Text(series.name)
        .font(.footnote)
        .lineLimit(2)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
        .frame(height: 35)
        .bold()
     }
    .frame(width: 110)
  }
}

//#Preview {
//  MoviesMainView()
//}
//

