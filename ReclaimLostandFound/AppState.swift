import SwiftUI
internal import Combine
import Supabase

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        Task {
            await verifySession()
        }
    }

    @MainActor
    private func setLoggedIn(_ loggedIn: Bool) {
        isLoggedIn = loggedIn
    }

    private func verifySession() async {
        let client = SupabaseManager.shared.client
        do {
            let session = try await client.auth.session
            await setLoggedIn(session.user != nil)
        } catch {
            await setLoggedIn(false)
        }
    }
}
