//
//  DataLogic.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/20/25.
//
//  This file will be used to objectify and save data to database
//  It will also be used to retreive objects from the database
//

import Foundation
import CoreLocation

class Room {
    var roomNumber: Int?
    var expiration: Date?
    var location: CLLocationCoordinate2D?
    var lostItems: [String: ThingLost]! = [:]
    
    
    
    init(roomNum: Int, expire: Date? = nil, latitude: CLLocationDegrees? = nil, longitude: CLLocationDegrees? = nil ) {
        roomNumber = roomNum
        if let exp = expire {
            expiration = exp
        }
        if let lat = latitude, let long = longitude {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }
    
    public func getRoomNumber() -> Int? {
        return roomNumber
    }
    
    public func getExpiration() -> Date? {
        return expiration
    }
    
    public func getLocation() -> CLLocationCoordinate2D? {
        return location
    }
    
    public func addLostItem(thingName: String) {
        lostItems[thingName] = ThingLost(iName: thingName)
    }
}

class ThingLost {
    var itemName: String?
    
    init(iName: String) {
        itemName = iName
    }
}
