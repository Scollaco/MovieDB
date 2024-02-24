import Foundation
import Dependencies
import SwiftUI
import CoreData

public struct MoviesMainView: View {
  var dependencies: Dependencies
  var service: MoviesService
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
    self.service = MoviesService(dependencies: dependencies)
  }
    public var body: some View {
        Text("movies")
        .task {
          do {
            let nowPlaying = try await service.fetchNowPlayingMovies()
            print(nowPlaying)
          } catch {
            print(error)
          }
        }
    }
}
//
//#Preview {
//  MoviesMainView()
//}
//
//
