//
//  Restaraunt.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

struct Restaraunt: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var imageURL: String
    var type: String
    var rating: Float
    var addressFull: String
    var addressLat: Double
    var addressLon: Double
    var phone: String
    var description: String
    var capacity: Int
    var tablePrice: Float
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case imageURL = "image_url"
        case type = "type"
        case rating = "rating"
        case addressFull = "address_full"
        case addressLat = "address_lat"
        case addressLon = "address_lon"
        case phone = "phone"
        case description = "description"
        case capacity = "capacity"
        case tablePrice = "table_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Results: Codable {
    var items: [Restaurant]
}
