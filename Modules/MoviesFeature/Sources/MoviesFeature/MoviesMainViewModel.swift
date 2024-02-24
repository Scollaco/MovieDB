import Foundation

final class MainViewModel: ObservableObject {
  let service: Service
  @Published var nowPlayingMovies: [Movie] = []
  @Published var popularMovies: [Movie] = []
  @Published var topratedMovies: [Movie] = []
  @Published var upcomingMovies: [Movie] = []
  
  init(service: Service) {
    self.service = service
  }
}
