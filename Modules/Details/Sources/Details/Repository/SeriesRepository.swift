import CoreData
import Dependencies
import Storage

public final class SeriesRepository {
  private let repository:  CoreDataStore<SeriesEntity>
  
  public init() {
    repository = CoreDataStore<SeriesEntity>()
  }
}

extension SeriesRepository: SeriesRepositoryInterface {
  // Get a gook using a predicate
  @MainActor 
  @discardableResult public func getSeries(
    predicate: NSPredicate? = nil,
    sortDescriptors: [NSSortDescriptor]? = nil
  ) -> Result<[SeriesDetails], Error> {
    let result = repository.get(predicate: predicate, sortDescriptors: sortDescriptors)
    switch result {
    case .success(let seriesEntity):
      // Transform the NSManagedObject objects to domain objects
      let series = seriesEntity.map { seriesEntity -> SeriesDetails in
        return seriesEntity.toDomainModel()
      }
      return .success(series)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
  // Creates a book on the persistance layer.
  @discardableResult public func create(series: SeriesDetails) -> Result<Bool, Error> {
    let result = repository.create()
    switch result {
    case .success(let seriesEntity):
      seriesEntity.backdropPath = series.backdropPath
      seriesEntity.posterPath = series.posterPath
      seriesEntity.id = series.id
      seriesEntity.originalName = series.originalName
      seriesEntity.name = series.name
      seriesEntity.overview = series.overview
      try? repository.context.save()
      return .success(true)
    case .failure(let error):
      // Return the Core Data error.
      return .failure(error)
    }
  }
  
  public func delete(series: SeriesDetails) {
    guard let seriesEntity = repository.get(with: series.id) else { return }
    _ = repository.delete(entity: seriesEntity)
  }
  
  public func getSeries(with id: Int) -> SeriesDetails? {
    let seriesEntity = repository.get(with: id)
    return seriesEntity?.toDomainModel()
  }
}
