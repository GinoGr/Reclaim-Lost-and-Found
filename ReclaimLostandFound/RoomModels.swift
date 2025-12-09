import Foundation

struct RoomInsert: Encodable { //encodable allows the types in this struct to be interpreted to json types when uploaded to the database
    let room_code: String
    let name: String
    let password: String
    let created_by: UUID
    let expires_at: Date?
    let address: String?
}

struct RoomRow: Decodable, Identifiable { // Decodable allows this struct to be made using json variables for when they are grabbed from the databse
    let id: UUID
    let room_code: String
    let name: String
    let password: String
    let created_by: UUID
    let expires_at: Date?
    let address: String?
}

struct RoomMemberInsert: Encodable {
    let room_id: UUID
    let user_id: UUID
    let role: String
}

struct JoinedRoomRow: Decodable, Identifiable { // Each instance of this struct will be unique. Thanks to id var and keyword identifiable. This will allow me to use foreach without specifying the idea for each instance in the loop. 
    var id: UUID { rooms.id }
    let rooms: RoomRow
    let role: String
}
