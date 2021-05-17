//
//  Schedule.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import Foundation

struct Schedule: Codable, Hashable, Identifiable {
    var id: Int
    var placeID: Int
    var workStart: String?
    var workEnd: String?
    var lunchStart: String?
    var lunchEnd: String?
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case placeID = "place_id"
        case workStart = "work_start"
        case workEnd = "work_end"
        case lunchStart = "lunch_start"
        case lunchEnd = "lunch_end"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

struct WeekSchedule: Codable {
    var data: [Schedule]
    
}
