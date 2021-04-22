//
//  Review.swift
//  Booking Application
//
//  Created by student on 20.04.21.
//

import Foundation

struct Review: Codable, Hashable, Identifiable {
    var id: Int
    var title: String
    var rating: Int
    var description: String
    var like: Int
    var placeId: Int
    var userId: Int
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case rating = "rating"
        case description = "description"
        case like = "like"
        case placeId = "place_id"
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}
