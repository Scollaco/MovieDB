import SwiftUI
import UIComponents
import AVKit

struct SeriesDetailsView: View {
  @ObservedObject private var viewModel: SeriesDetailsViewModel
  
  public init(viewModel: SeriesDetailsViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 10) {
        if let url = $viewModel.details.wrappedValue?.trailerURL {
          VideoPlayerView(videoUrl: url)
            .frame(height: 230)
        }
        
        Text($viewModel.details.wrappedValue?.name ?? .init())
          .font(.title2)
          .bold()
          .multilineTextAlignment(.center)
        
        if let tagline = $viewModel.details.wrappedValue?.tagline, !tagline.isEmpty {
          Text(tagline)
            .font(.caption)
            .bold()
            .padding(.horizontal)
            .multilineTextAlignment(.center)
        }
        
        Text($viewModel.details.wrappedValue?.overview ?? .init())
          .font(.footnote)
          .padding()
        
        if !$viewModel.providers.isEmpty {
          ProvidersSection(items: $viewModel.providers)
        }
        
        ScrollView(showsIndicators: false) {
          if !$viewModel.seasons.isEmpty {
            DetailListSection(
              title: "Seasons",
              items: $viewModel.seasons.wrappedValue
            )
            .padding(.bottom)
          }
       
          if !$viewModel.similarSeries.isEmpty {
            DetailListSection(
              title: "Similar Series",
              items: $viewModel.similarSeries.wrappedValue
            )
            .padding(.bottom)
          }
       
          if !$viewModel.recommendatedSeries.isEmpty {
            DetailListSection(
              title: "People Also Watched",
              items: $viewModel.recommendatedSeries.wrappedValue
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
          ProviderCell(provider: provider)
        }
      }
    }
    .padding()
  }
}

struct ProviderCell: View {
  @Binding var provider: WatchProvider
  
  var body: some View {
    if let url = URL(string: provider.logoUrl) {
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
      .frame(width: 40, height: 40)
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
  }
}

struct DetailListSection: View {
  let title: String
  let items: [Listable]
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(items, id: \.id) { series in
            ImageViewCell(
              imageUrl: series.imageUrl,
              title: series.name,
              placeholder: "tv"
            )
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

#Preview {
  SeriesDetailsView(
    viewModel: SeriesDetailsViewModel(
      series: .mock(),
      service: MockService())
  )
}
