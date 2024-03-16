import Foundation

protocol MovieRepositoryInterface {
  /// Get a movie using a predicate
  func getMovies(predicate: NSPredicate?) -> Result<[MovieDetails], Error>
  // Creates a movie on the persistance layer.
  func create(movie: MovieDetails) -> Result<Bool, Error>
}
