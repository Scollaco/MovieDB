import Foundation

struct MovieVideoResponse: Decodable {
  let id: Int
  let results: [MovieVideo]
}

enum VideoType: String {
  case extendedPreview = "Extended Preview"
  case internationalTrailer = "International Trailer"
  case specialFeaturesPreview = "Special Features Preview"
}

struct MovieVideo: Decodable {
  
}
