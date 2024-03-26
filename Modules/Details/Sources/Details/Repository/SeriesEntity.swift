import Foundation
import CoreData
import Storage

@objc(SeriesEntity)
class SeriesEntity: NSManagedObject {
  @NSManaged public var backdropPath: String?
  @NSManaged public var posterPath: String?
  @NSManaged public var id: Int
  @NSManaged public var originalName: String
  @NSManaged public var overview: String
  @NSManaged public var name: String
}

extension SeriesEntity: DomainModel {
  func toDomainModel() -> SeriesDetails {
    SeriesDetails.mock(
      backdropPath: backdropPath,
      posterPath: posterPath,
      id: id,
      originalName: originalName,
      overview: overview,
      name: name
    )
  }
}

extension SeriesEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SeriesEntity> {
        NSFetchRequest<SeriesEntity>(entityName: "SeriesEntity")
    }
}
