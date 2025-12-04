import SwiftUI
import Supabase

struct HomePageUIView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                HStack {
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
                    Spacer()
                    Button("Log out") {
                                    logOut()
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                                )
                                .foregroundColor(.white)
                    Spacer()
                }
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
                    MyRoomsView()
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
    private func logOut() {
        Task {
            do {
                try await SupabaseManager.shared.client.auth.signOut()
                await MainActor.run {
                    appState.isLoggedIn = false
                }
            } catch {
                print("Logout error: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomePageUIView()
            .preferredColorScheme(.dark)
    }
    .environmentObject(AppState())
}

struct MyRoomsView: View {
    @State private var createdRooms: [RoomRow] = []
    @State private var joinedRooms: [RoomRow] = []
    @State private var isCreatedExpanded = true
    @State private var isJoinedExpanded = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                // CREATED ROOMS
                DisclosureGroup(isExpanded: $isCreatedExpanded) {
                    if createdRooms.isEmpty {
                        Text("You haven’t created any rooms yet.")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(createdRooms) { room in
                                RoomCard(room: room)
                            }
                        }
                        .padding(.top, 8)
                    }
                } label: {
                    Text("Created Rooms")
                        .font(.headline)
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(16)

                // JOINED ROOMS
                DisclosureGroup(isExpanded: $isJoinedExpanded) {
                    if joinedRooms.isEmpty {
                        Text("You haven’t joined any rooms yet.")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(joinedRooms) { room in
                                RoomCard(room: room)
                            }
                        }
                        .padding(.top, 8)
                    }
                } label: {
                    Text("Joined Rooms")
                        .font(.headline)
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(16)

                Spacer()
            }
            .padding()
        }
        .task {
            await loadRooms()
        }
    }

    // MARK: - Data loading

    private func loadRooms() async {
        do {
            let client = SupabaseManager.shared.client

            guard let user = client.auth.currentUser else {
                await MainActor.run {
                    errorMessage = "You must be logged in to view rooms."
                }
                return
            }

            // 1) Rooms I created
            let myCreatedRooms: [RoomRow] = try await client
                .from("rooms")
                .select()
                .eq("created_by", value: user.id)
                .execute()
                .value

            // 2) Rooms I joined (via room_members → rooms)
            let joinedRows: [JoinedRoomRow] = try await client
                .from("room_members")
                .select("rooms(*), role")
                .eq("user_id", value: user.id)
                .eq("role", value: "Member")
                .execute()
                .value

            await MainActor.run {
                createdRooms = myCreatedRooms
                joinedRooms = joinedRows.map { $0.rooms }
                errorMessage = nil
            }
        } catch {
            print("Load rooms error:", error)
            await MainActor.run {
                errorMessage = "Failed to load rooms."
            }
        }
    }
}

struct RoomCard: View {
    let room: RoomRow

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(room.name)
                .font(.title3)
            Text("Code: \(room.room_code)")
                .font(.subheadline)
                .foregroundColor(.white)

            if let expires = room.expires_at {
                Text("Expires: \(expires.formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
    }
}
