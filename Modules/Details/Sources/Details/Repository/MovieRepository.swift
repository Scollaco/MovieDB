import CoreData
import Storage

public final class MovieRepository {
  private let repository: CoreDataRepository<MovieEntity>
  
  public init() {
    repository = CoreDataRepository()
  }
}

extension MovieRepository: MovieRepositoryInterface {
  // Get a gook using a predicate
  @discardableResult public func getMovies(
    predicate: NSPredicate? = nil,
    sortDescriptors: [NSSortDescriptor]? = nil
  ) -> Result<[MovieDetails], Error> {
    let result = repository.get(predicate: predicate, sortDescriptors: sortDescriptors)
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
  @discardableResult public func create(movie: MovieDetails) -> Result<Bool, Error> {
    let result = repository.create()
    switch result {
    case .success(let movieEntity):
      movieEntity.backdropPath = movie.backdropPath
      movieEntity.posterPath = movie.posterPath
      movieEntity.overview = movie.overview
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
  
  public func delete(movie: MovieDetails) {
    guard let movieEntity = repository.get(with: movie.id) else { return }
    _ = repository.delete(entity: movieEntity)
  }
  
  public func getMovie(with id: Int) -> MovieDetails? {
    let movieEntity = repository.get(with: id)
    return movieEntity?.toDomainModel()
  }
}
