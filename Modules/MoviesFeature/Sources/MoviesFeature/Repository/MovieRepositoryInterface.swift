import Foundation

protocol MovieRepositoryInterface {
  /// Get a movie by id
  func getMovie(with id: Int) -> MovieDetails?
  /// Get a list of movies using a predicate
  func getMovies(predicate: NSPredicate?) -> Result<[MovieDetails], Error>
  // Creates a movie on the persistance layer.
  func create(movie: MovieDetails) -> Result<Bool, Error>
  // Deletes a movie from the persistance layer.
  func delete(movie: MovieDetails)
}
