//
//  AllRestarauntsViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

class AllRestaurantViewModel: ObservableObject {
    var controller: AllRestaurantsViewController?
    @Published var places = [Place]()

}
