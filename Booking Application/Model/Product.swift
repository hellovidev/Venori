//
//  Product.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import Foundation

struct Product: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var weight: String
    var price: Float
    var imageURL: String
    var categoryID: Int
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case weight = "weight"
        case price = "price"
        case imageURL = "image_url" //storage/products/coffe_americano.png
        case categoryID = "category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}
