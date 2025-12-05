import SwiftUI
import Supabase

struct RoomDetailView: View {
    let room: RoomRow          // from your models
    let role: String?          // "Creator" / "Member" if you have it

    // later you’ll replace this with items loaded from Supabase
    @State private var items: [ItemRow] = []
    @State private var showingAddItemSheet = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // gradient background matching your app
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Room header card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(room.name)
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)

                            Spacer()

                            if let role = role {
                                Text(role)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(999)
                                    .foregroundColor(.white)
                            }
                        }
                        HStack {
                            Text("Room code: \(room.room_code)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                            Spacer()
                            
                            Text("Password: \(room.password)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                        }
                        if let expires = room.expires_at {
                            Text("Expires: \(expires.formatted(date: .abbreviated, time: .shortened))")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                        } else {
                            Text("No expiration set")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.5))
                        }

                        if let lat = room.location_lat,
                           let lng = room.location_lng {
                            Text("Location attached • (\(lat, specifier: "%.4f"), \(lng, specifier: "%.4f"))")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                        } else {
                            Text("No location attached")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.35))
                    .cornerRadius(20)
                    .shadow(radius: 12)

                    // MARK: - Lost Items section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Lost Items")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if(role == "Creator") {
                                Button {
                                    showingAddItemSheet = true
                                } label: {
                                    Text("Add Item")
                                        .font(.subheadline.bold())
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(16)
                                }
                            }
                        }
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }

                        if items.isEmpty {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                                .frame(maxWidth: .infinity, minHeight: 140)
                                .overlay(Text("No items yet.\nTap \"Add Item\" to create one.")
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                        .padding()
                                )
                        } else {
                            VStack(spacing: 8) {
                                ForEach(items) { item in
                                    ItemRowView(item: item)
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingAddItemSheet) {
            AddItemSheet(room: room) { newItem in
                items.insert(newItem, at: 0)
                }
            }
        .task {
            await loadItems()
        }
        .navigationTitle("Room Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    private func loadItems() async {
        do {
            let client = SupabaseManager.shared.client
            let loaded: [ItemRow] = try await client
                .from("items")
                .select()
                .eq("room_id", value: room.id)
                .order("created_at", ascending: false)
                .execute()
                .value

            await MainActor.run { items = loaded }
        } catch {
            print("loadItems error:", error)
            await MainActor.run {
                errorMessage = "Failed to load items."
            }
        }
    }
}

struct ItemRowView: View {
    let item: ItemRow

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let urlString = item.image_url,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Color.gray.opacity(0.3)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.white)

                if let description = item.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }

                Text(item.created_at.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}


#Preview {
    NavigationStack {
        RoomDetailView(
            room: RoomRow(
                id: UUID(),
                room_code: "123456",
                name: "Example Room",
                password: "password",
                created_by: UUID(),
                expires_at: nil,
                location_lat: 5.0,
                location_lng: 6.0
            ),
            role: "Creator"
        )
    }
}
