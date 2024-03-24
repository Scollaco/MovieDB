import Foundation
import CoreData
import Storage

@objc(DetailsEntity)
class DetailsEntity: NSManagedObject {
  @NSManaged public var backdropPath: String?
  @NSManaged public var posterPath: String?
  @NSManaged public var id: Int
  @NSManaged public var overview: String
  @NSManaged public var title: String
}

extension DetailsEntity: DomainModel {
  func toDomainModel() -> Details {
    Details(
      backdropPath: backdropPath,
      id: id,
      posterPath: posterPath,
      title: title,
      name: title,
      overview: overview
    )
  }
}

extension DetailsEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailsEntity> {
        NSFetchRequest<DetailsEntity>(entityName: "DetailsEntity")
    }
}
