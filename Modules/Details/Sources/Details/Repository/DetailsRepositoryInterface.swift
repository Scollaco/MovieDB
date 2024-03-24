import Foundation

public protocol DetailsRepositoryInterface {
  /// Get a series by id
  func get(with id: Int) -> Details?
  /// Get a series using a predicate
  func getAll(
    predicate: NSPredicate?,
    sortDescriptors: [NSSortDescriptor]?
  ) -> Result<[Details], Error>
  /// Creates a series on the persistance layer.
  func create(object: Details) -> Result<Bool, Error>
  /// Deletes a series from the persistance layer.
  func delete(object: Details)
}
