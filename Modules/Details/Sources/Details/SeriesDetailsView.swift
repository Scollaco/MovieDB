import SwiftUI
import Dependencies
import UIComponents
import Routing
import AVKit

public struct SeriesDetailsView: View {
  @ObservedObject private var viewModel: DetailsViewModel
  private let dependencies: Dependencies
  private weak var coordinator: DetailsCoordinator?
  
  init(
    viewModel: DetailsViewModel,
    dependencies: Dependencies,
    coordinator: DetailsCoordinator?
  ) {
    self.viewModel = viewModel
    self.dependencies = dependencies
    self.coordinator = coordinator
  }
  
  public var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 10) {
        if let url = $viewModel.seriesDetails.wrappedValue?.trailerURL {
          VideoPlayerView(videoUrl: url)
            .frame(height: 230)
        }
        
        Text($viewModel.seriesDetails.wrappedValue?.name ?? .init())
          .font(.title2)
          .bold()
          .multilineTextAlignment(.center)
        
        if let tagline = $viewModel.seriesDetails.wrappedValue?.tagline, !tagline.isEmpty {
          Text(tagline)
            .font(.caption)
            .bold()
            .padding(.horizontal)
            .multilineTextAlignment(.center)
        }
        
        ExpandableText(text: $viewModel.seriesDetails.wrappedValue?.overview ?? .init(), compactedLineLimit: 6)
          .font(.footnote)
          .padding()
        
        if $viewModel.reviewsSectionIsVisible.wrappedValue,
           let id = viewModel.seriesDetails?.id{
          NavigationLink(destination: {
            coordinator?.get(page: .reviews(id: id))
          }, label: {
            HStack {
              Text("Reviews")
                .bold()
              Text("(\($viewModel.reviews.count))")
              Spacer()
              Image.init(systemName: "chevron.forward")
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .tint(.primary)
          })
          .padding(.horizontal)
        }
        
        if !$viewModel.providers.isEmpty {
          ProvidersSection(items: $viewModel.providers)
        }
        
        ScrollView(showsIndicators: false) {
          if !$viewModel.seasons.isEmpty {
            DetailListSection(
              title: "Seasons",
              items: $viewModel.seasons.wrappedValue,
              dependencies: dependencies,
              coordinator: coordinator
            )
            .padding(.bottom)
          }
          
          if !$viewModel.similarSeries.isEmpty {
            DetailListSection(
              title: "Similar Series",
              items: $viewModel.similarSeries.wrappedValue,
              dependencies: dependencies,
              coordinator: coordinator
            )
            .padding(.bottom)
          }
          
          if !$viewModel.recommendatedSeries.isEmpty {
            DetailListSection(
              title: "People Also Watched",
              items: $viewModel.recommendatedSeries.wrappedValue,
              dependencies: dependencies,
              coordinator: coordinator
            )
          }
        }
        .padding()
      }
    }
    .toolbar {
      Button(action: {
        viewModel.addSeriesToWatchlist()
      }, label: {
        Image(systemName: viewModel.watchlistIconName)
      }
      )
    }
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.fetchSeriesDetails()
    }
  }
}

struct DetailListSection: View {
  let title: String
  let items: [Listable]
  let dependencies: Dependencies
  let coordinator: DetailsCoordinator?
  @State private var isPresenting = false
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { series in
            BottomSheet(series: series, coordinator: coordinator)
          }
        }
      }
    }  header: {
      Text(title)
        .font(.title2)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct BottomSheet: View {
  @State private var isPresenting = false
  var series: Listable
  let coordinator: DetailsCoordinator?

  var body: some View {
    Button(action: {
      isPresenting.toggle()
    }, label: {
      ImageViewCell(
        imageUrl: series.imageUrl,
        title: series.name,
        placeholder: "tv"
      )
    })
    .sheet(isPresented: $isPresenting) {
      coordinator?.get(page: .seriesDetails(id: series.id))
    }
  }
}

//#Preview {
//  SeriesDetailsView(
//    viewModel: SeriesDetailsViewModel(
//      series: .mock(),
//      service: MockService())
//  )
//}
