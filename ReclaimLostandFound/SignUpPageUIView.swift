//
//  LoginPageUIView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/25/25.
//

import SwiftUI
import Supabase

struct SignUpPageUIView: View {
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
                    .repeatForever(),
                value: animateBackground
            )

            VStack(spacing: 50) {
                Spacer()
                
                //MARK: - TITLE
                Text("Create Account")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Spacer()
                VStack(spacing: 25) {
                    //MARK: - Email Section
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty) {
                            Text("Enter Email")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 12)
                        }
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .roomTextFieldStyle()
                }

                VStack(spacing: 25) {
                    //MARK: - Password Section
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        
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
                        }
                        else {
                            TextField("", text: $passWord)
                                .placeholder(when: passWord.isEmpty) {
                                    Text("Enter Password")
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal, 12)
                                }
                                .roomTextFieldStyle()
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
                    }
                    if let confirmation = confirmation {
                        Text(confirmation)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()
                Spacer()
                
                //MARK: - Signup Button
                Button {
                    Task { await signUp() }
                } label: {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay( //Another view over the label. Will be used to make button style shape
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 70)
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
    //MARK: - Sign Up DB Logic
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
                confirmation = "Check your email for account creation..."
            }
        } catch {
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
