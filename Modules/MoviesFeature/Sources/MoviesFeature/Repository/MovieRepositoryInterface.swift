import Foundation

protocol MovieRepositoryInterface {
  /// Get a movie using a predicate
  func getMovies(predicate: NSPredicate?) -> Result<[Movie], Error>
  // Creates a movie on the persistance layer.
  func create(movie: Movie) -> Result<Bool, Error>
}
