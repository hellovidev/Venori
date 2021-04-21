//
//  User.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

// Email: qqqqq@gmail.com, Password: qqqqqqqqq

struct User: Codable, Hashable, Identifiable {
    var id: Int
    var firstName: String
    var secondName: String
    var email: String
    var addressFull: String?
    var addressLat: Double?
    var addressLon: Double?
    var avatar: String?
    var emailVerifiedAt: String?
    var createdAt: String
    var updatedAt: String
    
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

struct Account: Codable {
    var user: User
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case token = "access_token"
    }
}
