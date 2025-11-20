//
//  ReclaimLostandFoundApp.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/18/25.
//

import SwiftUI
import CoreData

@main
struct ReclaimLostandFoundApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomePageUIView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
