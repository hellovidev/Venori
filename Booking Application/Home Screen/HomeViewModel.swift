//
//  HomeViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

class HomeViewModel: ObservableObject {
    var controller: HomeViewController?
    @Published var categories = [Category]()
}
