import CoreData
import Dependencies
import Storage

public final class DetailsRepository {
  private let repository:  CoreDataRepository<DetailsEntity>
  
  public init() {
    repository = CoreDataRepository<DetailsEntity>()
  }
}

extension DetailsRepository {
  // Get a gook using a predicate
  @MainActor
  @discardableResult public func getAll(
    predicate: NSPredicate? = nil,
    sortDescriptors: [NSSortDescriptor]? = nil
  ) -> Result<[Details], Error> {
    let result = repository.get(predicate: predicate, sortDescriptors: sortDescriptors)
    switch result {
    case .success(let detailsEntity):
      // Transform the NSManagedObject objects to domain objects
      let details = detailsEntity.map { detailsEntity -> Details in
        return detailsEntity.toDomainModel()
      }
      return .success(details)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
  // Creates a book on the persistance layer.
  @discardableResult public func create(object: Details) -> Result<Bool, Error> {
    let result = repository.create()
    switch result {
    case .success(let detailsEntity):
      detailsEntity.backdropPath = object.backdropPath
      detailsEntity.id = object.id
      detailsEntity.title = (object.title ?? object.name ?? "")
      detailsEntity.overview = object.overview ?? ""
      detailsEntity.posterPath = object.posterPath
      try? repository.context.save()
      return .success(true)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
  
  public func delete(objectId: Int) {
    guard let detailsEntity = repository.get(with: objectId) else { return }
    _ = repository.delete(entity: detailsEntity)
  }
  
  public func get(with id: Int) -> Details? {
    let detailsEntity = repository.get(with: id)
    return detailsEntity?.toDomainModel()
  }
}
