import Dependencies
import SwiftUI
import CoreData

struct Item: Identifiable {
  let id = UUID()
  let name: String
}

struct ContentView: View {
  //var dependencies: Dependencies
  private var items: [Item] = [.init(name: "1"), .init(name: "2")]//FetchedResults<Item>
  init() {
    //self.dependencies = dependencies
  }
    var body: some View {
        //NavigationView {
            
            List {
                ForEach(items) { item in
                    NavigationLink {
                      Text("Item at \(item.name)")
                    } label: {
                      Text(item.name)
                    }
                }
//                .onDelete(perform: deleteItems)
            }
        //}
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}
//
#Preview {
  ContentView()
}


struct ContentView2: View {
  private var items: [Item] = [.init(name: "3"), .init(name: "4")]
  init() {}
    var body: some View {
            List {
                ForEach(items) { item in
                    NavigationLink {
                      Text("Item at \(item.name)")
                    } label: {
                      Text(item.name)
                    }
                }
            }
    }
}

#Preview {
  ContentView2()
}
