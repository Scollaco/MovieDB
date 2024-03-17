import Foundation

protocol SeriesRepositoryInterface {
  /// Get a series by id
  func getSeries(with id: Int) -> SeriesDetails?
  /// Get a series using a predicate
  func getSeries(predicate: NSPredicate?) -> Result<[SeriesDetails], Error>
  /// Creates a series on the persistance layer.
  func create(series: SeriesDetails) -> Result<Bool, Error>
  /// Deletes a series from the persistance layer.
  func delete(series: SeriesDetails)
}
