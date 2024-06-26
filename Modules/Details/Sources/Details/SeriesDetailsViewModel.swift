import Foundation

final class SeriesDetailsViewModel: ObservableObject {
  enum Icon: String {
    case bookmark = "bookmark.circle"
    case bookmarkFill = "bookmark.circle.fill"
  }
  
  private let service: DetailsService
  private let id: Int
  private let repository: SeriesRepositoryInterface

  @Published var seriesDetails: SeriesDetails?
  @Published var seasons: [SeriesDetails.Season] = []
  @Published var providers: [WatchProvider] = []
  @Published var similarSeries: [Details] = []
  @Published var recommendatedSeries: [Details] = []
  @Published var reviews: [Review] = []
  @Published var watchlistIconName: String = Icon.bookmark.rawValue
  @Published var reviewsSectionIsVisible: Bool = false
  @Published var overviewIsVisible: Bool = false
  @Published var genreListIsVisible: Bool = false
  @Published var directorsRowIsVisible: Bool = false

  init(
    id: Int,
    service: DetailsService,
    repository: SeriesRepositoryInterface
  ) {
    self.service = service
    self.id = id
    self.repository = repository

    fetchSeriesDetails()
  }
  
  func fetchSeriesDetails() {
    Task { @MainActor in
      do {
        seriesDetails = try await service.fetchSeriesDetails(id: id)
        similarSeries = seriesDetails?.similar?.results ?? []
        recommendatedSeries = seriesDetails?.recommendations?.results ?? []
        seasons = seriesDetails?.seasons ?? []
        generateProviders(for: seriesDetails?.watchProviders)
        watchlistIconName = isWatchlisted ? Icon.bookmarkFill.rawValue : Icon.bookmark.rawValue
        reviews = seriesDetails?.reviews ?? []
        reviewsSectionIsVisible = !reviews.isEmpty
        overviewIsVisible = seriesDetails?.overview != nil && !(seriesDetails?.overview.isEmpty ?? true)
        genreListIsVisible = !(seriesDetails?.genres?.isEmpty ?? true)
        directorsRowIsVisible = !(seriesDetails?.createdBy?.isEmpty ?? true)

      } catch {
        print(error)
      }
    }
  }
  
  func generateProviders(for response: WatchProviderResponse?) {
    let buy = response?.results.US?.buy ?? []
    let flatrate = response?.results.US?.flatrate ?? []
    let rent = response?.results.US?.rent ?? []
    providers = Array(Set(buy + flatrate + rent)).sorted(by: { $0.displayPriority < $1.displayPriority } )
  }
  
  func addSeriesToWatchlist() {
    guard let series = seriesDetails else { return }
    guard !isWatchlisted else {
      _ = repository.delete(series: series)
      watchlistIconName = Icon.bookmark.rawValue
      return
    }
    _ = repository.create(series: series)
    watchlistIconName = Icon.bookmarkFill.rawValue
  }
  
  var shareDetails: String {
    let name = seriesDetails?.name ?? ""
    guard !providers.isEmpty else {
      return "\n\n\(name)"
    }
    return "\n\n\(name)\n\nAvailable on: \(providers.map(\.providerName).joined(separator: ", "))"
  }
  
  private var isWatchlisted: Bool {
    guard let seriesDetails = seriesDetails,
          let _ = repository.getSeries(with: seriesDetails.id) else {
      return false
    }
    return true
  }
}
