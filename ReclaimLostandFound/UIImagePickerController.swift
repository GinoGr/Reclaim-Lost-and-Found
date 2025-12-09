import SwiftUI
import UIKit //Camera protocols found here

struct CameraPicker: UIViewControllerRepresentable { //SwiftUI is able to host a uikit view with this protocol
    @Environment(\.dismiss) var dismiss //Allows self dismissal
    @Binding var imageData: Data? //This is what returns to prarent view/function

    func makeUIViewController(context: Context) -> UIImagePickerController {//protocol req function.
        let picker = UIImagePickerController() //delegate
        picker.sourceType = .camera //using camera
        picker.delegate = context.coordinator //uikit coordinator handles whatever happens in camera view
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {} //protocol req function. Not implemented

    func makeCoordinator() -> Coordinator { //protocol req function.
        Coordinator(parent: self)
    } //Identify object to to return to. Self delegate because swiftui does not use delegates

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate { //Links the swiftui to uikit and allows image data to be retrived
        let parent: CameraPicker

        init(parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.85) { //Convert to jpeg (Compressed)
                parent.imageData = data
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
