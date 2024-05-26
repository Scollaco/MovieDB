import Foundation

public protocol DataStoreInterface<Entity> {
  /// The entity managed by the repository.
  associatedtype Entity
  
  /// Gets an array of NSManagedObject entities.
  /// - Parameters:
  ///   - predicate: The predicate to be used for fetching the entities.
  ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
  /// - Returns: A result consisting of either an array of NSManagedObject entities or an Error.
  func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>
  
  /// Creates a NSManagedObject entity.
  /// - Returns: A result consisting of either a NSManagedObject entity or an Error.
  func create() -> Result<Entity, Error>
  
  /// Deletes a NSManagedObject entity.
  /// - Parameter entity: The NSManagedObject to be deleted.
  /// - Returns: A result consisting of either a Bool set to true or an Error.
  func delete(entity: Entity) -> Result<Bool, Error>
  
  /// Gets a NSManagedObject by ID.
  /// - Parameters:
  ///   - id: The id of the object to be fetched.
  /// - Returns: A NSManagedObject, if found.
  func get(with id: Int) -> Entity?
}
