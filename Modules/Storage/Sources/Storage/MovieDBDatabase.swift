import Foundation
import MovieDBDependencies
import SwiftData

/// Enum for CoreData related errors
enum MovieDBDatabaseError: Error {
  case deletionError(Error)
  case fetchingError(Error)
  case invalidManagedObjectType
}


/// Generic class for handling NSManagedObject subclasses.
@ModelActor
public final actor MovieDBDatabase<T: PersistentModel & DomainModel> {
  /// Gets an array of NSManagedObject entities.
  /// - Parameters:
  ///   - descriptor: The fetch descriptors used for fetching the returned array of entities.
  /// - Returns: An array containing all objects.
  public func getAll(descriptor: FetchDescriptor<T>) throws -> [T.DomainModelType] {
    do {
      let allObjects = try modelContext.fetch(descriptor)
      return allObjects.map { $0.asDomainModel }
    } catch {
      throw MovieDBDatabaseError.fetchingError(error)
    }
  }
  
  /// Gets a NSManagedObject by ID.
  /// - Parameters:
  ///   - descriptor: The fetch descriptors used for fetching the returned array of entities.
  /// - Returns: The PersistentModel, if found.
  public func get(descriptor: FetchDescriptor<T>) throws -> T.DomainModelType? {
    do {
      return try modelContext.fetch(descriptor).first?.asDomainModel
    } catch {
      throw MovieDBDatabaseError.fetchingError(error)
    }
  }
  
  /// Creates a PersistentModel representation of a domain model..
  public func create(_ object: T.DomainModelType) throws {
    let newObject = T(object)
    modelContext.insert(newObject)
    do {
      try modelContext.save()
    } catch {
      throw MovieDBDatabaseError.invalidManagedObjectType
    }
  }
  
  /// Deletes a NSManagedObject entity.
  /// - Parameter predicate: The Predicate used to delete an object from the database..
  public func delete(predicate: Predicate<T>) throws {
    do {
      try modelContext.delete(model: T.self, where: predicate)
    } catch {
      throw MovieDBDatabaseError.deletionError(error)
    }
  }
}
