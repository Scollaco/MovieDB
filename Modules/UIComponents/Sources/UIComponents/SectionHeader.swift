import SwiftUI

public struct SectionHeader: View {
  let title: String
  public init(title: String) {
    self.title = title
  }
  
  public var body: some View {
    Text(title)
      .font(.title2)
      .bold()
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}
