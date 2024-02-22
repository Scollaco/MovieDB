//
//  MovieDBApp.swift
//  MovieDB
//
//  Created by Saturnino Collaco Teixeria Filho on 2/22/24.
//

import SwiftUI

@main
struct MovieDBApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
