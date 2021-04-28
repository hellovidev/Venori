//
//  Order.swift
//  Booking Application
//
//  Created by student on 22.04.21.
//

import Foundation

struct Order: Codable, Hashable, Identifiable {
    var id: Int
    var status: String
    var price: String
    var date: String
    var people: Int
    var staying: Int
    var time: String
    var stayingEnd: String
    var userID: Int
    var placeID: Int //***
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case price = "price"
        case date = "date"
        case people = "people"
        case staying = "staying"
        case time = "time"
        case stayingEnd = "staying_end"
        case userID = "user_id"
        case placeID = "place_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

struct Orders: Codable {
    var currentPage: Int
    var data: [Order]
    var firstPageURL: String
    var from: Int
    var lastPage: Int
    var lastPageURL: String
    var links: [Link]?
    var nextPageURL: String?
    var path: String
    var perPage: Int
    var prevPageURL: String?
    var to: Int
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
