//
//  Category.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

struct Category: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var image: String
    
    init(title: String, image: String) {
        self.id = UUID().uuidString
        self.title = title
        self.image = image
    }
}
