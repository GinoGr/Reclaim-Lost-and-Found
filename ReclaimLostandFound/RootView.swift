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

extension View {
    func roomTextFieldStyle() -> some View {
        self
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.black.opacity(0.85))
                    .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .foregroundColor(.white)
    }
    func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder content: () -> Content
        ) -> some View {
            ZStack(alignment: alignment) {
                self
                if shouldShow {
                    content()
                        .allowsHitTesting(false)
                }
            }
    }
    
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
