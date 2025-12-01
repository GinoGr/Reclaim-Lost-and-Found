
import Supabase
import Foundation

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        let url = URL(string: "https://uuxwkzfqbkmqcdvzussh.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1eHdremZxYmttcWNkdnp1c3NoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2MjAzNDgsImV4cCI6MjA4MDE5NjM0OH0.y0RMrVNlcdV2O6sMNnDfqWhEO_B7JSc3-VVgA2ebuBw"

        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
}
