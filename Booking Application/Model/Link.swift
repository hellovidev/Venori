//
//  Link.swift
//  Booking Application
//
//  Created by student on 22.04.21.
//

import Foundation

struct Link: Codable {
    var url: String?
    var label: String
    var active: Bool
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case label = "label"
        case active = "active"
    }

}
