//
//  LoginPageUIView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/25/25.
//

import SwiftUI
import Supabase //Database Library. Used for authentication

struct LoginPageUIView: View {
    @EnvironmentObject var appState: AppState //Logged in or not. Will be used to change root view
//EnviromentObject allows a global update this var and re renders all uiviews using this var.
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
                .repeatForever(),
                value: animateBackground
            ) //Change hue does not stop
            
            // MARK: - UIVIEW TITLE
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
                
                //MARK: - Email Section
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
                        .keyboardType(.emailAddress) //Changes the keyboard that pops up when typing in email
                        .placeholder(when: email.isEmpty) {
                            Text("Enter Email")
                                .foregroundColor(
                                    .white
                                        .opacity(0.5)
                                )
                                .padding(.horizontal, 12)
                        } //Changes The text shown on textfield and allows for customization to text. Custom function
                        .roomTextFieldStyle() //custom textfield style applied to all fields on app
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 10)
                        .animation(
                            .easeOut(duration: 0.6)
                            .delay(0.1),
                            value: animateContent
                        )
                }
                
                //MARK: - Password Section
                VStack(spacing: 25) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 10)
                        .animation(
                            .easeOut(duration: 0.6)
                            .delay(0.1),
                            value: animateContent
                        )
                    ZStack { //To overlay eye button over text field
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
                                    .easeOut(duration: 0.6)
                                    .delay(0.1),
                                    value: animateContent
                                )
                        }
                        else {
                            TextField("", text: $passWord)
                                .placeholder(when: passWord.isEmpty) {
                                    Text("Enter Password")
                                        .foregroundColor(
                                            .white
                                                .opacity(0.5)
                                        )
                                        .padding(.horizontal, 12)
                                }
                                .roomTextFieldStyle()
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 10)
                                .animation(
                                    .easeOut(duration: 0.6)
                                    .delay(0.1),
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
                    }
                }
                Spacer()
                Spacer()
                
                //asynchronous needed to allow user interface to continue rendering while atempting server contact. Using "Task" encapsulates the asynchronous action to just the items inside it.
                // MARK: - Login Button
                Button {
                    Task { await logIn() }
                } label: { //Label is the visible part of the button in this instance
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
    
    //MARK: - Login Logic
    // Function used for login logic with supabase
    // Uses async to call asynchronous function. Recomeneded when using network comms
    private func logIn() async { //Private to keep func local to this view
        do {
            //Get the globally shared Supabase client instance and store it in a local constant called client so I can use it for login calls
            let client = SupabaseManager.shared.client

            errorMessage = nil //Reset error message on each button click
            
            //Core login logic. Preform Supabase api call for authentication. Throws error sent from supabase on login problem. Network comm so suspend action while waiting for repsonse.
            _ = try await client.auth.signIn(
                email: email,
                password: passWord
            )
            
            //Main actor controls main thread. Must be ran as main thread to actively update UI. If main actor not specified, swift may choose to run as a background task/thread causing a lower priority and possible slow response
            await MainActor.run {
                appState.isLoggedIn = true
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription //user friendly description
            }
        }
    }
}

#Preview {
    LoginPageUIView()
        .environmentObject(AppState())
}

