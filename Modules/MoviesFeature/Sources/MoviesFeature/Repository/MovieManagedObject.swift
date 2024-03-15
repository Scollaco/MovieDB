import Foundation
import CoreData
import Storage
@objc(MovieManagedObject)

class MovieManagedObject: NSManagedObject {
  @NSManaged public var adult: Bool
  @NSManaged public var backdropPath: String?
  @NSManaged public var id: Int
  @NSManaged public var genreIds: [Int]
  @NSManaged public var originalLanguage: String
  @NSManaged public var originalTitle: String
  @NSManaged public var overview: String
  @NSManaged public var popularity: Double
  @NSManaged public var posterPath: String?
  @NSManaged public var releaseDate: String
  @NSManaged public var title: String
  @NSManaged public var voteAverage: Double
  @NSManaged public var voteCount: Int
}

extension MovieManagedObject: DomainModel {
  func toDomainModel() -> Movie {
    Movie(
      adult: adult,
      backdropPath: backdropPath,
      id: id,
      genreIds: genreIds,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      releaseDate: releaseDate,
      title: title,
      voteAverage: voteAverage,
      voteCount: voteCount
    )
  }
}
