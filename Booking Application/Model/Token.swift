//
//  Token.swift
//  Booking Application
//
//  Created by student on 20.04.21.
//

import Foundation

struct Token: Codable {
    private var token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
    
    func getToken() -> String {
        return self.token
    }
    
    mutating func setToken(token: String) {
        self.token = token
    }
}

//
//func getYearReleaseDate() -> String {
//    return String(date?.prefix(4) ?? "")
//}
