//
//  MapViewController.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import UIKit
import SwiftUI
import MapKit

class MapViewController: UIHostingController<MapViewDetails>  {
    private let viewModel = MapViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    init(latitude: Double, longitude: Double) {
        self.viewModel.latitude = latitude
        self.viewModel.longitude = longitude
        let view = MapViewDetails(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeMapView() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
