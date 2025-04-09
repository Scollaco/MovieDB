import Dependencies
import Foundation
import SwiftData
import Storage

extension MediaRepository: DependencyKey {
  public static let liveValue: Self = .live()
}

extension MediaRepository {
  static func live() -> Self {
    do {
      let database = try MovieDBDatabase<MediaEntity>(
        modelContainer: .init(
          for: MediaEntity.self,
          configurations: .init(
            "MovieDB.db",
            isStoredInMemoryOnly: false
          )
        )
      )
      
      return .init(
        getMedia: { id in
          try await database.get(
            descriptor: FetchDescriptor<MediaEntity>(
              predicate: #Predicate { $0.id == id }
            )
          )
        },
        getMedias: {
          try await database.getAll(
            descriptor: FetchDescriptor<MediaEntity>()
          )
        },
        create: { media in
          try await database.create(media)
        },
        delete: { id in
          try await database.delete(predicate: #Predicate { $0.id == id })
        }
      )
    } catch {
      fatalError("[Movie repository] Could not initiate database: \(error)")
    }
  }
}
