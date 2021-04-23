//
//  MapViewController.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import UIKit
import SwiftUI

class MapViewController: UIHostingController<MapViewDetails>  {
    private let state = MapViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    init() {
        let view = MapViewDetails(mapViewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeMapView() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
