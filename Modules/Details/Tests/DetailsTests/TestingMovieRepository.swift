import Foundation
@testable import Storage
@testable import Details

final class TestingMovieRepository: MovieRepositoryInterface {
  private let store: CoreDataStore<MovieEntity>
  init() {
    store = CoreDataStore()
  }
  
  func getMovie(with id: Int) -> Details.MovieDetails? {
    
  }
  
  func getMovies(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Details.MovieDetails], Error> {
    
  }
  
  func create(movie: Details.MovieDetails) -> Result<Bool, Error> {
    
  }
  
  func delete(movie: Details.MovieDetails) {
    
  }
}

extension CoreDataStore {
  
  convenience init(persistenceController: PersistenceController) {
    
  }
}
