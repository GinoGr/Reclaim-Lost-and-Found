//
//  RootView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/26/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                NavigationStack {
                    HomePageUIView()
                }
            } else {
                NavigationStack {
                    IntroUIView()
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
