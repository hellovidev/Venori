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
    var createdAt: String
    var updatedAt: String
    
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

struct Restaraunts: Codable {
    var data: [Restaraunt]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}


struct Restaurant: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var image: String
    var rating: Float
    var votes: Int
    
    init(title: String, image: String, rating: Float, votes: Int) {
        self.id = UUID().uuidString
        self.title = title
        self.image = image
        self.rating = rating
        self.votes = votes
    }
}
