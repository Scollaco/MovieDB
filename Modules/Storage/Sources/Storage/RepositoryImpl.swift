import CoreData
import Dependencies

/// Enum for CoreData related errors
enum CoreDataError: Error {
  case deletionError(String)
  case invalidManagedObjectType
}

/// Generic class for handling NSManagedObject subclasses.
public final class CoreDataRepository<T: NSManagedObject>: Repository {
  public typealias Entity = T
    
  /// The NSManagedObjectContext instance to be used for performing the operations.
  public let context = PersistenceController.shared.container.viewContext
  public let privateContext = PersistenceController.shared.privateContext
  
  public init() {}
  
  /// Gets an array of NSManagedObject entities.
  /// - Parameters:
  ///   - predicate: The predicate to be used for fetching the entities.
  ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
  /// - Returns: A result consisting of either an array of NSManagedObject entities or an Error.
  public func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
    // Create a fetch request for the associated NSManagedObjectContext type.
    let fetchRequest = Entity.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    do {
      // Perform the fetch request
      if let fetchResults = try context.fetch(fetchRequest) as? [Entity] {
        return .success(fetchResults)
      } else {
        return .failure(CoreDataError.invalidManagedObjectType)
      }
    } catch {
      return .failure(error)
    }
  }
  
  /// Gets a NSManagedObject by ID.
  /// - Parameters:
  ///   - id: The id of the object to be fetched.
  /// - Returns: A NSManagedObject, if found.
  public func get(with id: Int) -> Entity? {
    let result = get(
      predicate: NSPredicate(format: "id == %i", id),
      sortDescriptors: nil
    )
    switch result {
    case .success(let movie):
      return movie.first
    case .failure:
      return nil
    }
  }
  
  /// Creates a NSManagedObject entity.
  /// - Returns: A result consisting of either a NSManagedObject entity or an Error.
  public func create() -> Result<Entity, Error> {
    let newObject = Entity(context: context)
    do {
      try context.save()
      return .success(newObject)
    } catch {
      return .failure(CoreDataError.invalidManagedObjectType)
    }
  }
  
  /// Deletes a NSManagedObject entity.
  /// - Parameter entity: The NSManagedObject to be deleted.
  /// - Returns: A result consisting of either a Bool set to true or an Error.
  public func delete(entity: Entity) -> Result<Bool, Error> {
    context.delete(entity)
    do {
      try context.save()
      return .success(true)
    } catch {
      return .failure(CoreDataError.deletionError(error.localizedDescription))
    }
  }
}
