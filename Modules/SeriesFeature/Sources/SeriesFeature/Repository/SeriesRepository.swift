import CoreData
import Dependencies
import Storage

final class SeriesRepository {
  private let repository:  CoreDataRepository<SeriesEntity>
  
  init() {
    repository = CoreDataRepository<SeriesEntity>()
  }
}

extension SeriesRepository: SeriesRepositoryInterface {
  // Get a gook using a predicate
  @discardableResult func getSeries(predicate: NSPredicate?) -> Result<[SeriesDetails], Error> {
    let result = repository.get(predicate: predicate, sortDescriptors: nil)
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
  @discardableResult func create(series: SeriesDetails) -> Result<Bool, Error> {
    let result = repository.create()
    switch result {
    case .success(let seriesEntity):
      seriesEntity.backdropPath = series.backdropPath
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
}
