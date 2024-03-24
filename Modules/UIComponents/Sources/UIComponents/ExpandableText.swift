import SwiftUI

public struct ExpandableText: View {
  let text: String
  let compactedLineLimit: Int
  @State var expanded: Bool =  false
  @State var truncated: Bool =  false
  
  public init(text: String, compactedLineLimit: Int = 3) {
    self.text = text
    self.compactedLineLimit = compactedLineLimit
  }
  
  public var body: some View {
    VStack(alignment: .center) {
      Text(text)
        .lineLimit(expanded ? nil : compactedLineLimit)
        .background(
          Text(text)
            .lineLimit(compactedLineLimit)
            .background(
              GeometryReader { textGeometry in
                ZStack {
                  Text(text)
                    .background(
                      GeometryReader { fullTextGeometry in
                        Color.clear.onAppear {
                          truncated = fullTextGeometry.size.height > textGeometry.size.height
                        }
                      }
                    )
                }
                .frame(height: .greatestFiniteMagnitude)
              }
            )
            .hidden()
        )
      if truncated && !expanded {
        MoreButton(
          title: "Read more",
          action: {
            expanded.toggle()
          })
      } else if expanded {
        MoreButton(
          title: "Less",
          action: {
            expanded.toggle()
          })
      }
    }
  }
}

struct MoreButton: View {
  let title: String
  let action: () -> Void
  
  var body: some View {
    HStack {
      Button(action: {
        action()
      }, label: {
        Text(title)
          .bold()
          .tint(.primary)
      })
    }
  }
}
