//
//  Category.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

struct Categ: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var image: String
    
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}

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
    
    func getPosterLink() -> String {
        return Requests.domainLink.rawValue + imageURL
    }

}

struct Categories: Codable {
    var data: [Category]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
