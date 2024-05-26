import MovieDBDependencies
import Routing
import SwiftUI
import UIComponents
import Utilities

struct SeriesMainView: View {
  @ObservedObject private var viewModel: SeriesMainViewModel
  private let dependencies: MovieDBDependencies
  private weak var coordinator: SeriesCoordinator?

  init(
    viewModel: SeriesMainViewModel,
    dependencies: MovieDBDependencies,
    coordinator: SeriesCoordinator
  ) {
    self.viewModel = viewModel
    self.dependencies = dependencies
    self.coordinator = coordinator
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      ListSection(
        title: "Trending this week",
        category: .trending,
        viewModel: viewModel,
        items: $viewModel.trendingSeries.wrappedValue,
        dependencies: dependencies,
        coordinator: coordinator
      )
      .padding(.bottom)
      
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
      .padding(.bottom)
      
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
  let dependencies: MovieDBDependencies
  let coordinator: SeriesCoordinator?

  @State private var scrollPosition: CGFloat = .zero
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { series in
            ImageViewCell(
              imageUrl: series.imageUrl,
              title: series.name,
              rating: series.voteAverage
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

//#Preview {
//  SeriesMainView(
//    viewModel: SeriesMainViewModel(service: MockService())
//  )
//}
