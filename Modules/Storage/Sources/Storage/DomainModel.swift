import Foundation

public protocol DomainModel {
  associatedtype DomainModelType
  /// Creates a PersistenmtObject connresponding to a DomainModel type.
  init(_ domainModel: DomainModelType)
  /// Transforms an PersistentModel in a DomainModel type.
  var asDomainModel: DomainModelType { get }
}
