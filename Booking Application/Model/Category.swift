//
//  Category.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

struct Category: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var image: String
    
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
    
//    enum CodingKeys: String, CodingKey {
//        case title = "original_title"
//        case description = "overview"
//        case language = "original_language"
//        case date = "release_date"
//        case rating = "vote_average"
//        case posterPath = "poster_path"
//    }
//
//    func getPosterLink() -> String {
//        return API.posterResource.rawValue + (posterPath ?? "")
//    }
//
//    func getYearReleaseDate() -> String {
//        return String(date?.prefix(4) ?? "")
//    }
}

//struct Results: Codable {
//    var items: [Movie]
//}

