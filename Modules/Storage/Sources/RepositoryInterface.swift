import Foundation

protocol Repository {
  /// The entity managed by the repository.
  associatedtype T
  
  var objectDidUpdate: (() -> Void)? { get set }
  /**
   Returns all objects..
   - Parameters:
      - object: The new object to be created.
      - predicate: Predicate to filter results given a certain condition.
      - sortDescriptors: Descriptors to sort results..
   */
  func getAll(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) ->  Result<[T], Error>
  /**
   Creates a new instance of an object. If the object already exists, it updates the existing one.
   - Parameters:
      - object: The new object to be created.
   */
  func create(_ object: T)
   /**
    Deletes a  object.
    - Parameters:
       - object: The new object to be deleted
   */
  func delete(_ object: T)
  /**
   Updates an existing  object.
   - Parameters:
      - object: The object to be updated.
  */
  func update(_ object: T)
}
