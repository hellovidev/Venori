//
//  AllRestarauntsViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

class PlacesViewModel: ObservableObject {
    var controller: PlacesViewController?
    @Published var places = [Place]()
}
