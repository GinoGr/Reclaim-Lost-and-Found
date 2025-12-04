import SwiftUI

struct RoomDetailView: View {
    let room: RoomRow          // from your models
    let role: String?          // "Creator" / "Member" if you have it

    // later you’ll replace this with items loaded from Supabase
    @State private var items: [String] = []   // placeholder

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

                        Text("Room code: \(room.room_code)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))

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

                            Button {
                                // TODO: present sheet / push view to add item
                                print("Add item tapped")
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

                        if items.isEmpty {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                                .frame(maxWidth: .infinity, minHeight: 140)
                                .overlay(
                                    Text("No items yet.\nTap \"Add Item\" to create one.")
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                        .padding()
                                )
                        } else {
                            VStack(spacing: 8) {
                                ForEach(items, id: \.self) { item in
                                    HStack {
                                        Text(item)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Room Details")
        .navigationBarTitleDisplayMode(.inline)
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
