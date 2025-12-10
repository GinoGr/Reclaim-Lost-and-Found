import SwiftUI
import Supabase
import MapKit //Will be used to give address suggestions
internal import Combine //Used for publishing address suggestions

private var errorMessage: String?


struct CreateRoomUIView: View {
    @State private var roomName = ""
    @State private var roomPass = ""
    
    @State private var useExpiration = false
    @State private var expirationDate = Date()
    
    @State private var useLocation = false
    @StateObject private var search = AddressSearchService() //Will be used to update address suggestions. Create object instance with stateobject
    @State private var addressText = ""
    
    @State private var confirmationMessage: String?
        
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create Room")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)
                VStack(spacing: 24) {
                    
                    VStack {
                        Text("Room Name")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("", text: $roomName)
                            .placeholder(when: roomName.isEmpty) {
                                Text("Ex: \"John's House\"")
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
                        DatePicker ( //Built into SwiftUI
                            "Expiration:",
                            selection: $expirationDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                        .padding(.horizontal)
                    }
                    
                    Toggle("Attach Location", isOn: $useLocation)
                        .toggleStyle(SwitchToggleStyle(tint: .purple))
                        .padding(.horizontal)
                        
                    if useLocation {
                        TextField("", text: $addressText)
                            .placeholder(when: addressText.isEmpty) {
                                Text("Enter Address")
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal, 12)
                            }
                            .roomTextFieldStyle()
                            .onChange(of: addressText) { //On the change of input field, send new text to update suggestions in search object
                                search.updateQuery(addressText)
                            }
                        VStack {
                            List(search.suggestions, id: \.self) { suggestion in //Just like foreach, Lists require identifiable items (use id in this case)
                                VStack(alignment: .leading) {
                                    Text(suggestion.title)
                                    Text(suggestion.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture { //When a list item is tapped, preform... This is possible thanks to the identifier properties of the list items
                                    if suggestion.subtitle.isEmpty {
                                        addressText = suggestion.title
                                    } else {
                                        addressText = "\(suggestion.title), \(suggestion.subtitle)"
                                    }
                                    
                                    search.suggestions = []
                                }
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                            .frame(maxHeight: 100)
                            .offset(y: -20)
                        }
                        .frame(height: .infinity)
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
                    
                        
                }
                .frame(maxHeight: .infinity)
                
            }
            .padding(.horizontal, 24)
            VStack {
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
                    .frame(maxWidth: 350)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.7), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
                }
            }
            
        }
    }
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

            // build payload to insert to supabase
            let payload = RoomInsert(
                room_code: code,
                name: roomName,
                password: roomPass,
                created_by: user.id,
                expires_at: useExpiration ? expirationDate : nil,
                address: useLocation ? addressText: nil
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




#Preview {
    CreateRoomUIView()
        .preferredColorScheme(.dark)
}

// Search service
final class AddressSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var suggestions: [MKLocalSearchCompletion] = [] //Stores array of suggestions. This type has main suggestion and sub suggestion

    private let completer = MKLocalSearchCompleter() // The actual completer object

    override init() {
        super.init() // init nsobject for obj-c class
        completer.delegate = self //send delegate results to this instance
        completer.resultTypes = .address // result types should be addresses no landmarks, etc
    }

    func updateQuery(_ text: String) { //Called everytime input changes
        completer.queryFragment = text
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) { //A required function to conform to completer protocol. Will run everytime queryfragment is updated
        suggestions = completer.results //Send back results
    }
}
