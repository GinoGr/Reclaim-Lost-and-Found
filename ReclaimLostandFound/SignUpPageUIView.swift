//
//  LoginPageUIView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/25/25.
//

import SwiftUI

struct SignUpPageUIView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateContent = false
    @State private var animateBackground = false
    @State private var userName = ""
    @State private var passWord = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .hueRotation(.degrees(animateBackground ? 15 : -15))
            .animation(
                .easeInOut(duration: 8)
                    .repeatForever(autoreverses: true),
                value: animateBackground
            )

            VStack(spacing: 24) {
                Spacer()
                Text("Create Account")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.1),
                        value: animateContent
                    )
                Spacer()
                Text("UserName")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.1),
                        value: animateContent
                    )
                TextField("Create Username", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.1),
                        value: animateContent
                    )
                
                Text("Password")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.1),
                        value: animateContent
                    )
                TextField("Create Password", text: $passWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.1),
                        value: animateContent
                    )
                
                Spacer()
                Spacer()
                
                Button(action : {appState.isLoggedIn = true}) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
            }
            .navigationTitle("Sign Up")
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 40)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.9)
                    .delay(0.3),
                value: animateContent
            )
        }
        .onAppear {
            animateContent = true
            animateBackground = true
        }
    }
}

#Preview {
    SignUpPageUIView()
        .environmentObject(AppState())
}
