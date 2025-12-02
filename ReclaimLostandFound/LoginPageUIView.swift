//
//  LoginPageUIView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/25/25.
//

import SwiftUI
import Supabase

struct LoginPageUIView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var animateContent = false
    @State private var animateBackground = false
    @State private var email = ""
    @State private var passWord = ""
    @State private var errorMessage: String?
    @State private var isPasswordVisible: Bool = false

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

            VStack(spacing: 50) {
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
                VStack(spacing: 25) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 10)
                        .animation(
                            .easeOut(duration: 0.6).delay(0.1),
                            value: animateContent
                        )
                    TextField("", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .placeholder(when: email.isEmpty) {
                            Text("Enter Email")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 12)
                        }
                        .roomTextFieldStyle()
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 10)
                        .animation(
                            .easeOut(duration: 0.6).delay(0.1),
                            value: animateContent
                        )
                }
                
                VStack(spacing: 25) {
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
                    ZStack {
                        if(!isPasswordVisible) {
                            SecureField("", text: $passWord)
                                .placeholder(when: passWord.isEmpty) {
                                    Text("Enter Password")
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal, 12)
                                }
                                .roomTextFieldStyle()
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 10)
                                .animation(
                                    .easeOut(duration: 0.6).delay(0.1),
                                    value: animateContent
                                )
                        }
                        else {
                            TextField("", text: $passWord)
                                .placeholder(when: passWord.isEmpty) {
                                    Text("Enter Password")
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal, 12)
                                }
                                .roomTextFieldStyle()
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 10)
                                .animation(
                                    .easeOut(duration: 0.6).delay(0.1),
                                    value: animateContent
                                )
                        }
                        HStack {
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ?  "eye.fill" :  "eye.slash.fill")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 10)
                            .animation(
                                .easeOut(duration: 0.6).delay(0.1),
                                value: animateContent
                            )
                    }
                }
                Spacer()
                Spacer()
                
                Button {
                    Task { await logIn() }
                } label: {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16)
                }
                .contentShape(Rectangle())
                .padding(.horizontal)


            }
            .navigationTitle("Log In")
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
    private func logIn() async {
        do {
            let client = SupabaseManager.shared.client

            _ = try await client.auth.signIn(
                email: email,
                password: passWord
            )

            await MainActor.run {
                appState.isLoggedIn = true
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    LoginPageUIView()
        .environmentObject(AppState())
}

