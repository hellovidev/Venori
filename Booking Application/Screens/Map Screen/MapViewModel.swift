//
//  MapViewModel.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import MapKit
import Foundation

class MapViewModel: ObservableObject {
    weak var controller: MapViewController?
    @Published var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()

}

