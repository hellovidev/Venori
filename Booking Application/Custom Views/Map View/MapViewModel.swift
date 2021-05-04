//
//  MapViewModel.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import Foundation

class MapViewModel: ObservableObject {
    weak var controller: MapViewController?
    @Published var latitude: Double?
    @Published var longitude: Double?
}
