import SwiftUI
import CoreLocation
internal import Combine
import Supabase

private var errorMessage: String?

extension CreateRoomUIView {
    private func generateRoomCode() -> String {
        String(Int.random(in: 100_000...999_999))
    }

    private func createRoom() async {
        do {
            let client = SupabaseManager.shared.client

            guard let user = client.auth.currentUser else {
                print("Not logged in")
                return
            }

            let code = generateRoomCode()
            let coord = locationManager.lastCoordinate

            // 1) build payload
            let payload = RoomInsert(
                room_code: code,
                name: roomName,
                password: roomPass,
                created_by: user.id,
                expires_at: useExpiration ? expirationDate : nil,
                location_lat: useLocation ? coord?.latitude : nil,
                location_lng: useLocation ? coord?.longitude : nil
            )

            let createdRoom: RoomRow = try await client
                .from("rooms")
                .insert(payload)
                .select()
                .single()
                .execute()
                .value

            let membership = RoomMemberInsert(room_id: createdRoom.id, user_id: user.id, role: "Creator")

            try await client
                .from("room_members")
                .insert(membership)
                .execute()

            print("Room created with code:", createdRoom.room_code)
            confirmationMessage = "Room Created with code \(createdRoom.room_code)"


        } catch {
            print("Create room error:", error)
        }
    }
}


struct CreateRoomUIView: View {
    @State private var roomName = ""
    @State private var roomPass = ""
    
    @State private var useExpiration = false
    @State private var expirationDate = Date()
    
    @State private var useLocation = false
    @StateObject private var locationManager = LocationManager()
    
    @State private var confirmationMessage: String?
        
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
                    
                    VStack() {
                        Text("Room Name")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        TextField("", text: $roomName)
                            .placeholder(when: roomName.isEmpty) {
                                Text("Enter Room Name")
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
                    
                    Toggle("Add Expiration Date", isOn: $useExpiration)
                        .toggleStyle(SwitchToggleStyle(tint: .purple))
                        .padding(.horizontal)
                    
                    if useExpiration {
                        DatePicker (
                            "Expiration",
                            selection: $expirationDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                        .padding(.horizontal)
                    }
                    
                    Toggle("Attach Location", isOn: $useLocation)
                        .toggleStyle(SwitchToggleStyle(tint: .purple))
                        .padding(.horizontal)
                        .onChange(of: useLocation) {value in
                            if value {
                                locationManager.requestLocation()
                            }
                        }
                    
                    if useLocation {
                        if let coord = locationManager.lastCoordinate {
                            Text("Location: \(coord.latitude), \(coord.longitude)")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal)
                        } else {
                            Text("Getting location...")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal)
                        }
                    }
                    
                    if let confirmationMessage = confirmationMessage {
                        Text(confirmationMessage)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    Spacer()
                        
                    Button {
                        Task {
                            errorMessage = nil
                            confirmationMessage = nil
                            await createRoom()
                        }
                    } label: {
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
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}




#Preview {
    CreateRoomUIView()
        .preferredColorScheme(.dark)
}


final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var lastCoordinate: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestLocation() {

        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastCoordinate = locations.last?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        errorMessage = "Failed to get location"
        
    }
}
