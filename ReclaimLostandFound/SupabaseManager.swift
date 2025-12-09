
import Supabase
import Foundation //Needed to use "URL"

//This class will let me use my database accross all files using the same client instance. Using the Singleton Pattern allows for user session state save. Built into supabase library.
class SupabaseManager {
    static let shared = SupabaseManager() // This same object call will pertain to all instances of the manager

    let client: SupabaseClient //Communication with supabase through this client

    // Store url and key for accessing the database. Only accesible by this class
    private init() {
        let url = URL(string: "https://uuxwkzfqbkmqcdvzussh.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1eHdremZxYmttcWNkdnp1c3NoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2MjAzNDgsImV4cCI6MjA4MDE5NjM0OH0.y0RMrVNlcdV2O6sMNnDfqWhEO_B7JSc3-VVgA2ebuBw"

        client = SupabaseClient(supabaseURL: url, supabaseKey: key) // initiate the client with the respective database
    }
}
