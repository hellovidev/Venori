//
//  Time.swift
//  Booking Application
//
//  Created by student on 30.04.21.
//

import Foundation

struct Time: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var time: String
    
    init(time: String) {
        self.time = time
    }

}
