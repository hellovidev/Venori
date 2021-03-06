//
//  Category.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

struct Category: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var imageURL: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case imageURL = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

struct Categories: Codable {
    var currentPage: Int
    var data: [Category]
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
