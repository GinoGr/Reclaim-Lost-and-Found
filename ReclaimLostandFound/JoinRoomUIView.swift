import SwiftUI
import Supabase

struct JoinRoomUIView: View {
    @State private var roomNumber = ""
    @State private var roomPass = ""
    @State private var errorMessage: String?
    @State private var confirmation: String?

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

                    VStack() {
                        Text("Room Number")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        TextField("", text: $roomNumber)
                            .placeholder(when: roomNumber.isEmpty) {
                                Text("Enter Room Number")
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal, 12)
                            }
                            .roomTextFieldStyle()
                    }


                    VStack() {
                        Text("Room Password")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        TextField("", text: $roomPass)
                            .placeholder(when: roomPass.isEmpty) {
                                Text("Enter Room Password")
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal, 12)
                            }
                            .roomTextFieldStyle()
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    if let confirmation = confirmation {
                        Text(confirmation)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()
                    Spacer()

                    Button {
                        Task {
                            errorMessage = nil
                            confirmation = nil
                            await joinRoom()
                        }
                    } label: {
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
    
    private func joinRoom() async {
        do {
            let client = SupabaseManager.shared.client

            guard let user = client.auth.currentUser else {
                await MainActor.run {
                    errorMessage = "You must be logged in to join a room."
                }
                return
            }

            // find room by code + password
            let room: RoomRow = try await client
                .from("rooms")
                .select()
                .eq("room_code", value: roomNumber)
                .eq("password", value: roomPass)
                .single()
                .execute()
                .value
            
            //insert membership
            let membership = RoomMemberInsert(room_id: room.id, user_id: user.id, role: "Member")

            do {
                try await client
                    .from("room_members")
                    .insert(membership)
                    .execute()
            } catch {
                // if already a member (duplicate key), you can ignore
                errorMessage = "Insert membership error: \(error)"
            }

            await MainActor.run {
                errorMessage = nil
                confirmation = "Joined room: \(room.name)"
            }

        } catch {
            print("Join room error:", error)
            await MainActor.run {
                errorMessage = "Invalid room code or password."
            }
        }
    }
}

#Preview {
    JoinRoomUIView()
        .preferredColorScheme(.dark)
}
