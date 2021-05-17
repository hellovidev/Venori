//
//  DetailsRestarauntViewController.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import SwiftUI

class PlaceDetailsViewController: UIHostingController<PlaceDetailsView>  {
    private let viewModel: PlaceDetailsViewModel
    
    // MARK: -> Make Navigation Bar Hidden

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: -> Make Status Bar Color Elements White

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(place: Place) {
        viewModel = PlaceDetailsViewModel(place: place)
        let view = PlaceDetailsView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Go To Previous Screen
    
    func redirectPrevious() {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: -> Go To Map
    
    func showMapView() {
        let navigationController = UINavigationController(rootViewController: MapViewController(latitude: viewModel.place.addressLat, longitude: viewModel.place.addressLon))
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Redirect User To Booking Process
    
    func redirectBookingProcess(placeIdentifier: Int) {
        let navigationController = UINavigationController(rootViewController: OrderProcessViewController(placeIdentifier: placeIdentifier))
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Redirect User To Reviews Of Place
    
    func redirectReviews(placeIdentifier: Int) {
        let navigationController = UINavigationController(rootViewController: ReviewsViewController(placeIdentifier: placeIdentifier))
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
}
