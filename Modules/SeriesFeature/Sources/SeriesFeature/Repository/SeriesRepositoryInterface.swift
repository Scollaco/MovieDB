import Foundation

protocol SeriesRepositoryInterface {
  /// Get a series using a predicate
  func getSeries(predicate: NSPredicate?) -> Result<[SeriesDetails], Error>
  // Creates a series on the persistance layer.
  func create(series: SeriesDetails) -> Result<Bool, Error>
}
