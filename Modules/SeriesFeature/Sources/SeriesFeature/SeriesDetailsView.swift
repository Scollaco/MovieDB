import SwiftUI
import Dependencies
import UIComponents
import Routing
import AVKit

public struct SeriesDetailsView: View {
  @ObservedObject private var viewModel: SeriesDetailsViewModel
  private let dependencies: Dependencies
  private weak var coordinator: SeriesCoordinator?
  
  init(
    viewModel: SeriesDetailsViewModel,
    dependencies: Dependencies,
    coordinator: SeriesCoordinator?
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
        
        Text($viewModel.seriesDetails.wrappedValue?.overview ?? .init())
          .font(.footnote)
          .padding()
        
        if $viewModel.reviewsSectionIsVisible.wrappedValue {
          NavigationLink(destination: {
            coordinator?.get(page: .reviews(id: viewModel.seriesDetails?.id))
          }, label: {
            HStack {
              Text("Reviews")
                .bold()
              Text("(\($viewModel.reviews.count))")
              Spacer()
              Image.init(systemName: "chevron.forward")
            }
            .padding()
            .background(.quinary)
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

struct ProvidersSection: View {
  @Binding var items: [WatchProvider]
  
  var body: some View {
    Text("Watch Now")
      .font(.title3)
      .bold()
    
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach($items, id: \.providerId) { provider in
          ProviderCell(url: provider.wrappedValue.logoUrl)
        }
      }
    }
    .padding()
  }
}

struct DetailListSection: View {
  let title: String
  let items: [Listable]
  let dependencies: Dependencies
  let coordinator: SeriesCoordinator?
  @State private var isPresenting = false
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { series in
            Button(action: {
              isPresenting = true
            }, label: {
              ImageViewCell(
                imageUrl: series.imageUrl,
                title: series.name,
                placeholder: "tv"
              )
            })
            .sheet(isPresented: $isPresenting) {
              coordinator?.get(page: .details(id: series.id))
            }
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

//#Preview {
//  SeriesDetailsView(
//    viewModel: SeriesDetailsViewModel(
//      series: .mock(),
//      service: MockService())
//  )
//}
