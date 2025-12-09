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

    @MainActor //This action following this property will be prioritize so it will run on main thread (run immediately)
    private func setLoggedIn(_ loggedIn: Bool) { //Function that changes app state
        isLoggedIn = loggedIn
    }

    private func verifySession() async { //This function will check to see if a user is logged in
        let client = SupabaseManager.shared.client
        do {
            try await client.auth.session //Checks supabase keychain to verify device's authentication state. (Log in persistence) throws if no session found
            setLoggedIn(true)
        } catch {
            setLoggedIn(false)
        }
    }
}
