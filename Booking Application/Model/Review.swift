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
    var rating: Float
    var description: String
    var like: Int
    var placeId: Int
    var userId: Int
    var createdAt: String
    var updatedAt: String
    
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

struct Reviews: Codable {
    var currentPage: Int
    var data: [Review]
    var firstPageURL: String
    var from: Int?
    var lastPage: Int
    var lastPageURL: String
    var links: [Link]?
    var nextPageURL: String?
    var path: String
    var perPage: Int
    var prevPageURL: String?
    var to: Int?
    var total: Int
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case firstPageURL = "first_page_url"
        case from = "from"
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links = "links"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }
    
}

