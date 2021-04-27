//
//  BookViewModel.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

class OrderProcessViewModel: ObservableObject {
    var controller: OrderProcessViewController?
    @Published var availableTime = [String]()
    @Published var placeID: Int?
}
