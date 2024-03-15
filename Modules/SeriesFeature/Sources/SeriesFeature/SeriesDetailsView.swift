import SwiftUI
import Dependencies
import UIComponents
import Routing
import AVKit

public struct SeriesDetailsView: View {
  @ObservedObject private var viewModel: SeriesDetailsViewModel
  private let dependencies: Dependencies
  private weak var coordinator: SeriesCoordinator?
  
  public init(
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
          .padding(.top)
        
        if viewModel.taglineIsVisible {
          Text($viewModel.seriesDetails.wrappedValue?.tagline ?? .init())
            .font(.caption)
            .bold()
            .padding(.horizontal)
            .multilineTextAlignment(.center)
        }
        
        Text($viewModel.seriesDetails.wrappedValue?.overview ?? .init())
          .font(.footnote)
          .padding()
        
        if !viewModel.providersSectionIsVisible {
          ProvidersSection(items: $viewModel.providers)
        }
        
        ScrollView(showsIndicators: false) {
          if viewModel.seasonsSectionIsVisible {
            DetailListSection(
              title: "Seasons",
              items: $viewModel.seasons.wrappedValue,
              dependencies: dependencies,
              coordinator: coordinator
            )
            .padding(.bottom)
          }
          
          if viewModel.similarSectionIsVisible {
            DetailListSection(
              title: "Similar Series",
              items: $viewModel.similarSeries.wrappedValue,
              dependencies: dependencies,
              coordinator: coordinator
            )
            .padding(.bottom)
          }
          
          if viewModel.recommendedSectionIsVisible {
            DetailListSection(
              title: "People Also Watched",
              items: $viewModel.recommendedSeries.wrappedValue,
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
        
      }, label: {
        Image.init(systemName: "square.and.arrow.up")
      }
      )
      Button(action: {
        
      }, label: {
        Image.init(systemName: "bookmark")
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
