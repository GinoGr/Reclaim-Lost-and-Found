import SwiftUI

struct CreateRoomUIView: View {
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
                    Text("Create Room")
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
                        print("Create Room tapped")
                    }) {
                        HStack {
                            Text("Create Room")
                                .fontWeight(.semibold)
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
    CreateRoomUIView()
        .preferredColorScheme(.dark)
}
