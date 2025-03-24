import SwiftUI
import UIComponents

struct ProvidersSection: View {
  var items: [WatchProvider]
  
  var body: some View {
    Text("Watch Now")
      .font(.title3)
      .bold()
    
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(items, id: \.providerId) { provider in
          ProviderCell(url: provider.logoUrl)
        }
      }
    }
    .padding()
  }
}
