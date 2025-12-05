import Foundation


struct ItemInsert: Encodable {
    let room_id: UUID
    let created_by: UUID
    let title: String
    let description: String?
    let image_url: String?
}

struct ItemRow: Decodable, Identifiable {
    let id: UUID
    let room_id: UUID
    let created_by: UUID
    let title: String
    let description: String?
    let image_url: String?
    let created_at: Date
}
