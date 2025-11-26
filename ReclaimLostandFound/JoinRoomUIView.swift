import SwiftUI

struct JoinRoomUIView: View {
    @State private var roomNumber = ""
    @State private var roomPass = ""
    
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
                    Text("Join Room")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)

                VStack(spacing: 16) {
                    Spacer()
                    Text("Room Number")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    TextField("Enter Room Number", text: $roomNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text("Room Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                                    
                    TextField("Enter Room Password", text: $roomPass)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                    Spacer()
                    
                    Button(action: {
                        print("Join Room tapped")
                    }) {
                        HStack {
                            Text("Join Room")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

#Preview {
    JoinRoomUIView()
        .preferredColorScheme(.dark)
}
