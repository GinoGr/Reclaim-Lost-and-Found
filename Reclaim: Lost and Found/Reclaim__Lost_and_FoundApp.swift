//
//  Reclaim__Lost_and_FoundApp.swift
//  Reclaim: Lost and Found
//
//  Created by csuftitan on 11/18/25.
//

import SwiftUI
import CoreData

@main
struct Reclaim__Lost_and_FoundApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
