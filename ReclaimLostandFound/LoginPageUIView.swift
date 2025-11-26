//
//  LoginPageUIView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/25/25.
//

import SwiftUI

struct LoginPageUIView: View {
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
                Text("Welcome Back!")
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
                TextField("Enter Username", text: $userName)
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
                TextField("Enter Password", text: $passWord)
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
                
                Button(action : {print("Login Check")}) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16)
                }
            }
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
    LoginPageUIView()
}
