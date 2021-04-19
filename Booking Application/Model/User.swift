//
//  User.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

struct User: Codable, Hashable, Identifiable {
    var id: String
    var firstName: String
    var secondName: String
    var email: String
    var addressFull: String
    var addressLat: String
    var addressLon: String
    var avatar: String
    var emailVerifiedAt: Bool
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case secondName = "second_name"
        case email = "email"
        case addressFull = "address_full"
        case addressLat = "address_lat"
        case addressLon = "address_lon"
        case avatar = "avatar"
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
