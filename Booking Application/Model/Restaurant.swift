//
//  Restaurant.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

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
