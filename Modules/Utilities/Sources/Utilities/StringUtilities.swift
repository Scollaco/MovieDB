import Foundation

public extension String {
  static func formattedDate(_ stringDate: String) -> String? {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    guard let finalDate = formatter.date(from: stringDate) else {
      return ""
    }
    formatter.dateStyle = .medium
    return formatter.string(from: finalDate)
  }
  
  var url: String {
    "https://image.tmdb.org/t/p/w500/\(self)"
  }
}
