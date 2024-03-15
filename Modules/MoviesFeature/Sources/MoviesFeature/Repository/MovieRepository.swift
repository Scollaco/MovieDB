import CoreData
import Storage

final class MovieRepository {
  private let repository: CoreDataRepository<MovieManagedObject>
  
  init() {
    repository = CoreDataRepository()
  }
}

extension MovieRepository: MovieRepositoryInterface {
  // Get a gook using a predicate
  @discardableResult func getMovies(predicate: NSPredicate?) -> Result<[Movie], Error> {
    let result = repository.get(predicate: predicate, sortDescriptors: nil)
    switch result {
    case .success(let moviesMO):
      // Transform the NSManagedObject objects to domain objects
      let movies = moviesMO.map { moviesMO -> Movie in
        return moviesMO.toDomainModel()
      }
      
      return .success(movies)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
  // Creates a book on the persistance layer.
  @discardableResult func create(movie: Movie) -> Result<Bool, Error> {
    let result = repository.create()
    switch result {
    case .success(let movieMO):
      movieMO.backdropPath = movie.backdropPath
      movieMO.id = movie.id
      movieMO.originalTitle = movie.originalTitle
      movieMO.popularity = movie.popularity
      movieMO.posterPath = movie.posterPath
      movieMO.title = movie.title
      movieMO.releaseDate = movie.releaseDate
      movieMO.voteAverage = movie.voteAverage
      movieMO.voteCount = movie.voteCount
      try? repository.context.save()
      return .success(true)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
}
