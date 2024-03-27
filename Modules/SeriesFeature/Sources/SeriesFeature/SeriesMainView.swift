import Dependencies
import Routing
import SwiftUI
import UIComponents
import Utilities

struct SeriesMainView: View {
  @ObservedObject private var viewModel: SeriesMainViewModel
  private let dependencies: Dependencies
  private weak var coordinator: SeriesCoordinator?

  init(
    viewModel: SeriesMainViewModel,
    dependencies: Dependencies,
    coordinator: SeriesCoordinator
  ) {
    self.viewModel = viewModel
    self.dependencies = dependencies
    self.coordinator = coordinator
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      ListSection(
        title: "Airing today",
        category: .airingToday,
        viewModel: viewModel,
        items: $viewModel.airingTodaySeries.wrappedValue,
        dependencies: dependencies,
        coordinator: coordinator
      )
      .padding(.bottom)
      
      ListSection(
        title: "Top rated",
        category: .topRated,
        viewModel: viewModel,
        items: $viewModel.topRatedSeries.wrappedValue,
        dependencies: dependencies,
        coordinator: coordinator
      )
      .padding(.bottom)
      
      ListSection(
        title: "Popular",
        category: .popular,
        viewModel: viewModel,
        items: $viewModel.popularSeries.wrappedValue,
        dependencies: dependencies,
        coordinator: coordinator
      )
      
      ListSection(
        title: "On the air",
        category: .onTheAir,
        viewModel: viewModel,
        items: $viewModel.onTheAirSeries.wrappedValue,
        dependencies: dependencies,
        coordinator: coordinator
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
  let items: [Series]
  let dependencies: Dependencies
  let coordinator: SeriesCoordinator?

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
            .onTapGesture {
              coordinator?.goToDetails(id: series.id)
            }
            .onAppear {
              if viewModel.shouldLoadMoreData(series.id, items: items) {
                viewModel.loadMoreData(for: category)
              }
            }
          }
        }
      }
    } header: {
      SectionHeader(title: title)
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
//  SeriesMainView(
//    viewModel: SeriesMainViewModel(service: MockService())
//  )
//}
