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
    @StateObject private var appState = AppState() //Object is created and owned here

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}
