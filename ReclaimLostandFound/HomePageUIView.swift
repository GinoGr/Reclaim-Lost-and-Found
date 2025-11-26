import SwiftUI

struct HomePageUIView: View {
    var body: some View {
        ZStack {
            // Same background as intro
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                // Top welcome block
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome, USER!")
                        .font(.title.bold())
                        .foregroundColor(.white)

                    Text("What would you like to do?")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)

                // Big buttons
                VStack(spacing: 16) {
                    Button(action: {
                        print("Join Room tapped")
                    }) {
                        HStack {
                            Image(systemName: "person.2.fill")
                            Text("Join Room")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                    }

                    Button(action: {
                        print("Create Room tapped")
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Room")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

#Preview {
    HomePageUIView()
        .preferredColorScheme(.dark)
}
