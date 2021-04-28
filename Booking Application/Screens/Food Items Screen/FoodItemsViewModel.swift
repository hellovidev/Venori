//
//  FoodItemsViewModel.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import Foundation

class FoodItemsViewModel: ObservableObject {
    weak var controller: FoodItemsViewController?
    @Published var categories = [Category]()
}
