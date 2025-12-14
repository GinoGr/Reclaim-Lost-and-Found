import SwiftUI
import Supabase

struct HomePageUIView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var animateBackground = false

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
                    // MARK: Join Room/Create Room
                    NavigationLink {
                        JoinRoomUIView()
                    } label: {
                        HStack {
                            Image(systemName: "person.3.fill")
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
                    //MARK: Display rooms view
                    MyRoomsView()
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .frame(width: .infinity, height: .infinity, alignment: .center)
        .onAppear{
            animateBackground = true
        }
    }
    //MARK: Logout function
    private func logOut() {
        Task {
            do {
                try await SupabaseManager.shared.client.auth.signOut() //App Persistence
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
    @State private var joinedMemberships: [JoinedRoomRow] = []
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

                //This is what is used to create an expandable view
                //MARK: Disclosure groups
                DisclosureGroup("Created Room", isExpanded: $isCreatedExpanded) {
                    if createdRooms.isEmpty {
                        Text("You haven’t created any rooms yet.")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(createdRooms) { room in //List all rooms in created rooms
                                NavigationLink { //Link each room to its respective detail page
                                    RoomDetailView(room: room, role: "Creator") //Call the detail page with the respective information (Params)
                                } label: {
                                    RoomCard(room: room, role: "Creator")
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                Task {await deleteRoom(room)}
                                            } label: {
                                                Label("Delete Room", systemImage: "trash")
                                            }
                                        }//Show the room debrief in card form using a new UIView and allows for deletion of room when task is called
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(16)

                DisclosureGroup("Joined Rooms", isExpanded: $isJoinedExpanded) {
                    if joinedMemberships.isEmpty {
                        Text("You haven’t joined any rooms yet.")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(joinedMemberships) { joined in
                                NavigationLink {
                                    RoomDetailView(room: joined.rooms, role: joined.role)
                                } label: {
                                    RoomCard(room: joined.rooms, role: joined.role)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
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
            guard let user = client.auth.currentUser else { return } //Just making sure

            //Rooms I created
            let myCreated: [RoomRow] = try await client
                .from("rooms")
                .select()
                .eq("created_by", value: user.id)
                .execute()
                .value

            //Rooms I joined (via room_members → rooms)
            let memberships: [JoinedRoomRow] = try await client
                .from("room_members")
                .select("rooms(*), role")// Supabase uses the room_members foreign key to return the nested room row (rooms(*))
                .eq("user_id", value: user.id)
                .eq("role", value: "Member")
                .execute()
                .value

            await MainActor.run {
                createdRooms = myCreated
                joinedMemberships = memberships
                errorMessage = nil
            }
        } catch {
            print("loadRooms error:", error)
            await MainActor.run {
                errorMessage = "Failed to load rooms."
            }
        }
    }
    
    // Deletes a room from Supabase and removes it from the local list.
    // - Parameter room: The room the user wants to delete.
    //
    // This function:
    // 1. Sends a delete request to Supabase targeting the specific room ID.
    // 2. Because the database uses `ON DELETE CASCADE`, all related items
    //    and room_members entries are deleted automatically.
    // 3. Updates the UI by removing the deleted room from `createdRooms`.
    // 4. Handles errors gracefully and displays a message in the UI.
    private func deleteRoom(_ room: RoomRow) async {
        do {
            // Send DELETE request to Supabase to remove the room by its ID.
            // Cascade delete rules in the database ensure all related data is also removed.
            try await SupabaseManager.shared.client
                .from("rooms")
                .delete()
                .eq("id", value: room.id)
                .execute()
            
            // Update UI on the main thread:
            // Remove the deleted room from the local array so the UI refreshes immediately.
            await MainActor.run {
                createdRooms.removeAll { $0.id == room.id }
            }
            
        } catch {
            // Log the error for debugging.
            print("Delete room error:", error)
            
            // Update UI by showing an error message to the user.
            await MainActor.run {
                errorMessage = "Failed to delete room."
            }
        }
    }

}



struct RoomCard: View {
    let room: RoomRow
    let role: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(room.name)
                .font(.headline)
                .foregroundColor(.white)

            Text("Code: \(room.room_code)")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))

            if let role = role {
                Text(role)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.25))
        .cornerRadius(12)
    }
}
