//
//  IntroUIView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/25/25.
//

import SwiftUI

struct IntroUIView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 24) {
                
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                
                Text("Reclaim: Lost And Found")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Less Searching.\nMore Finding")
                    .font(Font.title3)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {print("Log in")}) {
                        Text("LOG IN")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                    }
                    
                    Button(action: {print("Sign up")}) {
                        Text("SIGN UP")
                    }
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
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    IntroUIView()
        .preferredColorScheme(.dark)
}
