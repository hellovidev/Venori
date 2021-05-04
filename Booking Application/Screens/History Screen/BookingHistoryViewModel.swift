//
//  BookingHistoryViewModel.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import SwiftUI

class BookingHistoryViewModel: ObservableObject {
    weak var controller: BookingHistoryViewController?
    private let serviceAPI = ServiceAPI()
    @Published var orders = [Order]()
}
