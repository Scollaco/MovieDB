import Foundation
import CoreData
import Storage

@objc(MovieEntity)
class MovieEntity: NSManagedObject {
  @NSManaged public var backdropPath: String?
  @NSManaged public var posterPath: String?
  @NSManaged public var id: Int
  @NSManaged public var originalTitle: String
  @NSManaged public var overview: String
  @NSManaged public var releaseDate: String
  @NSManaged public var title: String
}

extension MovieEntity: DomainModel {
  func toDomainModel() -> MovieDetails {
    MovieDetails(
      backdropPath: backdropPath,
      posterPath: posterPath,
      genres: nil,
      id: id,
      originalTitle: originalTitle,
      title: title,
      overview: overview,
      releaseDate: releaseDate,
      tagline: nil,
      videos: .init(results: []),
      similar: .init(page: 1, results: []),
      recommendations: .init(page: 1, results: []), 
      watchProviders: .init(results: .init(US: nil)),
      reviews: nil,
      createdBy: []
    )
  }
}

extension MovieEntity {
    public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }
}
