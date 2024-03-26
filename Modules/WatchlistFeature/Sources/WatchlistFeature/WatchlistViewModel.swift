import Details
import Storage
import SwiftUI

final class WatchlistViewModel: ObservableObject {
  @Published var movies: [MovieDetails] = []
  @Published var series: [SeriesDetails] = []
  @Published var moviesSectionIsVisible: Bool = false
  @Published var seriesSectionIsVisible: Bool = false

  private var moviesRepository: MovieRepositoryInterface
  private var seriesRepository: SeriesRepositoryInterface
  
  init(
    moviesRepository: MovieRepositoryInterface,
    seriesRepository: SeriesRepositoryInterface
  ) {
    self.moviesRepository = moviesRepository
    self.seriesRepository = seriesRepository
  }
  
  func fetchData() {
    fetchSeries()
    fetchMovies()
  }
  
  private func fetchSeries() {
    let result = seriesRepository.getSeries(
      predicate: nil,
      sortDescriptors: nil
    )
    switch result {
    case .success(let series):
      self.series = series
      seriesSectionIsVisible = !series.isEmpty
    case .failure(let error):
      print(error)
    }
  }
  
  private func fetchMovies() {
    let result = moviesRepository.getMovies(
      predicate: nil,
      sortDescriptors: nil
    )
    switch result {
    case .success(let movies):
      self.movies = movies
      moviesSectionIsVisible = !movies.isEmpty
    case .failure(let error):
      print(error)
    }
  }
  
  func delete(movie: MovieDetails) {
    moviesRepository.delete(movie: movie)
    fetchMovies()
  }
  
  func delete(series: SeriesDetails) {
    seriesRepository.delete(series: series)
    fetchSeries()
  }
}
