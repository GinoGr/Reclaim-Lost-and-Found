import SwiftUI
import PhotosUI
import Supabase

struct AddItemSheet: View {
    let room: RoomRow
    var onItemAdded: (ItemRow) -> Void //Syntax to return to parent caller

    @Environment(\.dismiss) var dismiss //Allows sheet to dismiss itself

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var imageData: Data?
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var showingCamera = false
    @State private var isSaving = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Info") {
                    TextField("Item title", text: $title)
                    TextField("Description (optional)", text: $description, axis: .vertical)
                }

                Section("Photo") {

                    // PREVIEW
                    if let imageData, //not Swiftui/uikit friendly
                       let uiImage = UIImage(data: imageData) { //Display image in swiftui form
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    // From photo library (native PhotosPicker)
                    PhotosPicker("Choose Photo",
                                 selection: $selectedPickerItem,
                                 matching: .images)
                        .onChange(of: selectedPickerItem) { newItem in
                            guard let newItem else { return } //Did I select a photo or choose no photo
                            Task {
                                do {
                                    if let data = try await newItem.loadTransferable(type: Data.self) { //native photopicker function to retrieve selected photo data. Async because photo source may be networked or may be costly
                                        await MainActor.run { imageData = data }
                                    }
                                } catch {
                                    print("PhotosPicker load error:", error)
                                    await MainActor.run {
                                        errorMessage = "Failed to load image from library."
                                    }
                                }
                            }
                        }
                }

                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task { await saveItem() }
                    } label: {
                        if isSaving {
                            ProgressView() //Displays progress of awaiting tasks
                        } else {
                            Text("Save")
                        }
                    }
                    .disabled(title.isEmpty || isSaving)
                }
            }
        }
    }
    // MARK: - Save to Supabase

    private func saveItem() async {
        isSaving = true
        errorMessage = nil

        do {
            let client = SupabaseManager.shared.client

            guard let user = client.auth.currentUser else {
                errorMessage = "User Not Logged In"
                return
            }

            // Upload image if present
            var imageURLString: String? = nil

            if let data = imageData {
                let fileName = UUID().uuidString + ".jpg"
                let path = "\(room.id.uuidString)/\(fileName)"

                // upload to your bucket (make sure bucket name matches Supabase)
                try await client.storage
                    .from("item-photos")
                    .upload(path: path, file: data)

                let publicURL = try client.storage //Returns URL object
                    .from("item-photos")
                    .getPublicURL(path: path)

                imageURLString = publicURL.absoluteString
            }

            //Insert item row
            let payload = ItemInsert(
                room_id: room.id,
                created_by: user.id,
                title: title,
                description: description.isEmpty ? nil : description,
                image_url: imageURLString
            )

            let newItem: ItemRow = try await client
                .from("items")
                .insert(payload)
                .select()
                .single()
                .execute()
                .value

            await MainActor.run {
                onItemAdded(newItem)
                dismiss()
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }


        await MainActor.run { isSaving = false }
    }
}
