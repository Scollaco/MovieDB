import SwiftUI
import Dependencies
import UIComponents
import Routing
import AVKit

public struct SeriesDetailsView: View {
  @ObservedObject private var viewModel: SeriesDetailsViewModel
  private let dependencies: Dependencies
  
  public init(viewModel: SeriesDetailsViewModel, dependencies: Dependencies) {
    self.viewModel = viewModel
    self.dependencies = dependencies
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
        
        if !$viewModel.providers.isEmpty {
          ProvidersSection(items: $viewModel.providers)
        }
        
        ScrollView(showsIndicators: false) {
          if !$viewModel.seasons.isEmpty {
            DetailListSection(
              title: "Seasons",
              items: $viewModel.seasons.wrappedValue,
              dependencies: dependencies
            )
            .padding(.bottom)
          }
       
          if !$viewModel.similarSeries.isEmpty {
            DetailListSection(
              title: "Similar Series",
              items: $viewModel.similarSeries.wrappedValue,
              dependencies: dependencies
            )
            .padding(.bottom)
          }
       
          if !$viewModel.recommendatedSeries.isEmpty {
            DetailListSection(
              title: "People Also Watched",
              items: $viewModel.recommendatedSeries.wrappedValue,
              dependencies: dependencies
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

  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { series in
            NavigationModal(
              .sheet,
              value: SeriesRoutes.details(
                id: series.id,
                dependencies: dependencies
              ),
              data: SeriesRoutes.self,
              label: {
                ImageViewCell(
                  imageUrl: series.imageUrl,
                  title: series.name,
                  placeholder: "tv"
                )
              })
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
