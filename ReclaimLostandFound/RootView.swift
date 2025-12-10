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
        //Swift only allows one view to be displayed. Group is a view that can contain multiple views and switch between them.
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

extension View { //Going to be adding my own view modifier function
    func roomTextFieldStyle() -> some View { //The function outputs a view as all view modifiers do
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
    
    //Allows a view modification especially made for textfields. Allows for custom text and formating to be placed on a textfield (Swiftui does not natively allow this) <Content: View> allows for use as a view modifier
    func placeholder<Content: View>(
            when shouldShow: Bool, //Only applies modifier when this bool is true
            alignment: Alignment = .leading,
            @ViewBuilder content: () -> Content //Allows for closure that returns a view. Content is the view being built. Allows for views to be added to closure.
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
