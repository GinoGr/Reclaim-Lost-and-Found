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
            HStack() {
                Spacer()
                Text("Welcome, USER!").font(.title)
                Spacer()
                Spacer()
                VStack(spacing: 10){
                    Button( action: {
                        print("Button was clicked")
                    }) {
                        Text("Join Room")
                    }.background(.yellow).cornerRadius(5)
                    Button( action: {
                        print("Button was clicked")
                    }) {
                        Text("Create Room")
                    }.background(.yellow).cornerRadius(5)
                }
                Spacer()
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(20)
            .padding()
            .shadow(radius: 10)
            }
        Spacer()
    }
}

#Preview {
    HomePageUIView()
}
