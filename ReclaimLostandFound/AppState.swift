import SwiftUI
internal import Combine //used to observe changes. Employed by isLoggedIn var.
import Supabase

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false //Reactive variable. Whenever the variable is updated, All ui employing this variable will rerender

    init() {
        Task {
            await verifySession()
        }
    }

    private func verifySession() async { //This function will check to see if a user is logged in
        let client = SupabaseManager.shared.client
        do {
            try await client.auth.session //Checks supabase keychain to verify device's authentication state. (Log in persistence) throws if no session found
            await MainActor.run{
                isLoggedIn = true
            }
        } catch {
            await MainActor.run{
                isLoggedIn = false
            }
        }
    }
}
