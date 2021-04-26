//
//  AllRestarauntsViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI

class PlacesViewController: UIHostingController<PlacesView>  {
    private let state = PlacesViewModel()
    var serviceAPI = ServiceAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
        //***
//        serviceAPI.fetchDataAboutPlaces()
//        if serviceAPI.places != nil {
//            state.places = serviceAPI.places!.data!
//        }
        serviceAPI.fetchDataAboutPlaces(completion: {
            response in
            self.state.places = self.serviceAPI.places!.data!
        })
    }
    
    init() {
        let view = PlacesView(viewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Go Previous Screen
    
    func redirectPrevious() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -> Redirect User To Login Screen
    
    func redirectToPlaceDetails(object: Place) {
        let rootviewController = DetailsRestarauntViewController()
        rootviewController.place = object
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
}
