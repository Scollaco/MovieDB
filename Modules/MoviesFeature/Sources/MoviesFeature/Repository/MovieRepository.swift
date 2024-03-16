import CoreData
import Storage

final class MovieRepository {
  private let repository: CoreDataRepository<MovieEntity>
  
  init() {
    repository = CoreDataRepository()
  }
}

extension MovieRepository: MovieRepositoryInterface {
  // Get a gook using a predicate
  @discardableResult func getMovies(predicate: NSPredicate?) -> Result<[MovieDetails], Error> {
    let result = getMoviesEntities(predicate: predicate)
    switch result {
    case .success(let moviesMO):
      // Transform the NSManagedObject objects to domain objects
      let movies = moviesMO.map { moviesMO -> MovieDetails in
        return moviesMO.toDomainModel()
      }
      return .success(movies)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
  
  // Creates a book on the persistance layer.
  @discardableResult func create(movie: MovieDetails) -> Result<Bool, Error> {
    let result = repository.create()
    switch result {
    case .success(let movieEntity):
      movieEntity.backdropPath = movie.backdropPath
      movieEntity.id = movie.id
      movieEntity.originalTitle = movie.originalTitle
      movieEntity.title = movie.title
      movieEntity.releaseDate = movie.releaseDate
      try? repository.context.save()
      return .success(true)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
  
  func delete(movie: MovieDetails) {
    let result = getMoviesEntities(
      predicate: NSPredicate(
        format: "id == %@", String(describing: movie.id)
      )
    )
    
    switch result {
    case .success(let entities):
      if let entity = entities.first {
        _ = repository.delete(entity: entity)
      }
    case .failure:
      return
    }
  }
  
  func getMovie(with id: Int) -> MovieDetails? {
    let result = getMovies(
      predicate: NSPredicate(
        format: "id == %@", String(describing: id)
      )
    )
    switch result {
    case .success(let movie):
      return movie.first
    case .failure:
      return nil
    }
  }
  
  @discardableResult
  private func getMoviesEntities(predicate: NSPredicate?) -> Result<[MovieEntity], Error> {
    let result = repository.get(predicate: predicate, sortDescriptors: nil)
    switch result {
    case .success(let moviesMO):
      return .success(moviesMO)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
}
