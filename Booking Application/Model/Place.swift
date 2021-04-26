//
//  Restaraunt.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

struct Place: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var imageURL: String
    var type: String
    var rating: Float
    var addressFull: String
    var addressLat: Double
    var addressLon: Double
    var phone: String?
    var description: String
    var capacity: Int?
    var tablePrice: String
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

struct Places: Codable {
    var currentPage: Int
    var data: [Place]?
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
