import Dependencies
import Foundation
import SwiftData
import Storage

extension MediaRepository: DependencyKey {
  public static let liveValue: Self = .live()
}

extension MediaRepository {
  static func live() -> Self {
    do {
      let database = try MovieDBDatabase<MediaEntity>(
        modelContainer: .init(
          for: MediaEntity.self,
          configurations: .init(
            "MovieDB.db",
            isStoredInMemoryOnly: false
          )
        )
      )
      
      return .init(
        getMedia: { id in
          try await database.get(
            descriptor: FetchDescriptor<MediaEntity>(
              predicate: #Predicate { $0.id == id }
            )
          )
        },
        getMedias: {
          try await database.getAll(
            descriptor: FetchDescriptor<MediaEntity>()
          )
        },
        create: { media in
          try await database.create(media)
        },
        delete: { id in
          try await database.delete(predicate: #Predicate { $0.id == id })
        }
      )
    } catch {
      fatalError("[Movie repository] Could not initiate database: \(error)")
    }
  }
}
//
//extension MovieRepository: MovieRepositoryInterface {
//  @discardableResult public func getMovies(
//    predicate: NSPredicate? = nil,
//    sortDescriptors: [NSSortDescriptor]? = nil
//  ) -> Result<[MovieDetails], Error> {
//    let result = store.get(predicate: predicate, sortDescriptors: sortDescriptors)
//    switch result {
//    case .success(let moviesMO):
//      // Transform the NSManagedObject objects to domain objects
//      let movies = moviesMO.map { moviesMO -> MovieDetails in
//        return moviesMO.toDomainModel()
//      }
//      return .success(movies)
//    case .failure(let error):
//      // Return the Core Data error.
//      return .failure(error)
//    }
//  }
//  
//  // Creates a book on the persistance layer.
//  @discardableResult public func create(movie: MovieDetails) -> Result<Bool, Error> {
//    let result = store.create()
//    switch result {
//    case .success(let movieEntity):
//      movieEntity.backdropPath = movie.backdropPath
//      movieEntity.posterPath = movie.posterPath
//      movieEntity.overview = movie.overview
//      movieEntity.id = movie.id
//      movieEntity.originalTitle = movie.originalTitle
//      movieEntity.title = movie.title
//      movieEntity.releaseDate = movie.releaseDate
//      try? store.context.save()
//      return .success(true)
//    case .failure(let error):
//      // Return the Core Data error.
//      return .failure(error)
//    }
//  }
//  
//  public func delete(movie: MovieDetails) {
//    guard let movieEntity = store.get(with: movie.id) else { return }
//    _ = store.delete(entity: movieEntity)
//  }
//  
//  public func getMovie(with id: Int) -> MovieDetails? {
//    let movieEntity = store.get(with: id)
//    return movieEntity?.toDomainModel()
//  }
//}
