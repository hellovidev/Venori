//
//  MapViewController.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import MapKit
import SwiftUI

class MapViewController: UIHostingController<MapViewDetails>  {
    private let viewModel = MapViewModel()
    
    // MARK: -> Make Navigation Bar Hidden
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: -> Initialization SwiftUI View
    
    init(latitude: Double, longitude: Double) {
        self.viewModel.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.viewModel.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        let view = MapViewDetails(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Go To Previous Screen
    
    func redirectPrevious() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
