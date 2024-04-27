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
    <#code#>
  }
  
  func create(movie: Details.MovieDetails) -> Result<Bool, Error> {
    <#code#>
  }
  
  func delete(movie: Details.MovieDetails) {
    <#code#>
  }
  
  
}

extension CoreDataStore {
  
  convenience init(persistenceController: PersistenceController) {
    
  }
}
