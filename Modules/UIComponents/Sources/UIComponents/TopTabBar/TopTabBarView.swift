import SwiftUI

public struct TopTabBarView<Content>: View where Content: View {
  @State var currentTab: Int = 0
  
  let content: () -> Content
  let titles: [String]
  
  public init(
    titles: [String], 
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content
    self.titles = titles
  }
  
  public var body: some View {
    VStack {
      TabBarView(
        currentTab: $currentTab,
        tabBarTitles: titles
      )
      .padding(.bottom)
      
      TabView(selection: $currentTab) {
        content()
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .edgesIgnoringSafeArea(.all)
      
    
    }
    .padding()
  }
}

struct TabBarView: View {
  @Binding var currentTab: Int
  @Namespace var namespace
  
  let tabBarTitles: [String]
  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 20) {
        ForEach(
          Array(zip(tabBarTitles.indices, tabBarTitles)),
          id: \.0
        ) { index, title in
          TabBarItem(
            currentTab: $currentTab,
            namespace: namespace.self,
            tabBarItemName: title,
            tab: index
          )
        }
      }
      .padding(.horizontal)
    }
    .frame(height: 50)
    .edgesIgnoringSafeArea([.all])
  }
}

struct TabBarItem: View {
  @Binding var currentTab: Int
  let namespace: Namespace.ID
  var tabBarItemName: String
  var tab: Int
  
  var body: some View {
    Button {
      self.currentTab = tab
    } label: {
      VStack {
        Spacer()
        Text(tabBarItemName)
        if currentTab == tab {
          Color.black
            .frame(height: 2)
            .matchedGeometryEffect(
              id: "underline",
              in: namespace,
              properties: .frame
            )
        } else {
          Color.clear.frame(height: 2)
        }
      }
      .animation(.spring(), value: currentTab)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  TopTabBarView(titles: ["View 1", "View 2"]) {
    Color.yellow.tag(0)
    Color.blue.tag(1)
  }
}
