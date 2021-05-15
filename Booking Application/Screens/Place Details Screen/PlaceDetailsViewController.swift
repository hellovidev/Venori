//
//  DetailsRestarauntViewController.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import UIKit
import SwiftUI

class PlaceDetailsViewController: UIHostingController<PlaceDetailsView>  {
    private let viewModel: PlaceDetailsViewModel
    private var serviceAPI = ServerRequest()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
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
    
    func redirectToBooking() {
        let navigationController = UINavigationController(rootViewController: OrderProcessViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    func goBack() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    func showMapView() {
        let navigationController = UINavigationController(rootViewController: MapViewController(latitude: viewModel.place.addressLat, longitude: viewModel.place.addressLon))
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Redirect User To Booking Process

    func redirectToBookingProcess(object: Place) {
        let rootviewController = OrderProcessViewController()
        rootviewController.placeID = object.id
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Redirect User To Reviews Of Place

    func redirectReviews(placeIdentifier: Int) {
        let navigationController = UINavigationController(rootViewController: ReviewsViewController(placeIdentifier: placeIdentifier))
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    func showWeekSchedule(placeID: Int) {
        self.serviceAPI.getScheduleOfPlace(completion: { result in
                switch result {
                case .success(let weekSchedule):
                    self.viewModel.schedules = weekSchedule
                    print(weekSchedule)
                case .failure(let error):
                    print(error)
                }
        }, placeIdentifier: placeID)
    }
    
}
