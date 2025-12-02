//
//  LoginPageUIView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/25/25.
//

import SwiftUI
import Supabase

struct SignUpPageUIView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateContent = false
    @State private var animateBackground = false
    @State private var email = ""
    @State private var passWord = ""
    @State private var errorMessage: String?
    @State private var confirmation: String?
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
                        .placeholder(when: email.isEmpty) {
                            Text("Enter Email")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 12)
                        }
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
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
                            .foregroundColor(.red)
                            .font(.footnote)
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 10)
                            .animation(
                                .easeOut(duration: 0.6).delay(0.1),
                                value: animateContent
                            )
                    }
                    if let confirmation = confirmation {
                        Text(confirmation)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                Spacer()
                
                Button {
                    Task { await signUp() }
                } label: {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
                .contentShape(Rectangle())
                .padding(.horizontal)

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
    private func signUp() async {
        do {
            let client = SupabaseManager.shared.client
            errorMessage = nil
            confirmation = nil
            _ = try await client.auth.signUp(
                email: email,
                password: passWord
            )
            await MainActor.run {
                confirmation = "Check your email for account creation"
            }
        } catch {
            
            print("Sign up error:", error)
            print("Localized:", error.localizedDescription)
            
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    SignUpPageUIView()
        .environmentObject(AppState())
}
