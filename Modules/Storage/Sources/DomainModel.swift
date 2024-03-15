import Foundation

public protocol DomainModel {
  associatedtype DomainModelType
  /// Transforms an NSManagedObject in a DomainModel type.
  func toDomainModel() -> DomainModelType
}
