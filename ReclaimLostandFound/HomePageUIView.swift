import SwiftUI

struct HomePageUIView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {

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

                VStack(spacing: 16) {
                    
                    NavigationLink {
                        JoinRoomUIView()
                    } label: {
                        HStack {
                            Image(systemName: "person.2.fill")
                            Text("Join Room")
                            Spacer()
                        }
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16)
                    }
                    
                    NavigationLink {
                        CreateRoomUIView()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Room")
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
