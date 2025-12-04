import Foundation

struct RoomInsert: Encodable {
    let room_code: String
    let name: String
    let password: String
    let created_by: UUID
    let expires_at: Date?
    let location_lat: Double?
    let location_lng: Double?
}

struct RoomRow: Decodable, Identifiable {
    let id: UUID
    let room_code: String
    let name: String
    let password: String
    let created_by: UUID
    let expires_at: Date?
    let location_lat: Double?
    let location_lng: Double?
}

struct RoomMemberInsert: Encodable {
    let room_id: UUID
    let user_id: UUID
    let role: String
}

struct JoinedRoomRow: Decodable, Identifiable {
    var id: UUID { rooms.id }   // forward id so ForEach can use it
    let rooms: RoomRow
    let role: String
}
