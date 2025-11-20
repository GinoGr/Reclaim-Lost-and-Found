//
//  HomePageUIView.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/18/25.
//

import SwiftUI

struct HomePageUIView: View {
    var body: some View {
        VStack() {
            Text("Welcome, USER!").font(.title)
                .padding()
                .background(Color.blue)
                .cornerRadius(20)
                .padding()
                .shadow(radius: 10)
            HStack(spacing: 25) {
                Button( action: {
                    print("Button was clicked")
                }) {
                    Text("Join Room").foregroundStyle(.black)
                }.cornerRadius(5)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                Button( action: {
                    print("Button was clicked")
                }) {
                    Text("Create Room").foregroundStyle(.black)
                }.cornerRadius(5)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
        Spacer()
    }
}

#Preview {
    HomePageUIView()
}
