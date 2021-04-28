//
//  DetailsRestarauntViewController.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import UIKit
import SwiftUI

class DetailsRestarauntViewController: UIHostingController<DetailsRestarauntView>  {
    private let state = DetailsRestarauntViewModel()
    var place: Place?
    private var serviceAPI = ServiceAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        state.place = place
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init() {
        let view = DetailsRestarauntView(viewModel: state)
        super.init(rootView: view)
        state.controller = self
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
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showMapView() {
        let navigationController = UINavigationController(rootViewController: MapViewController())
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
    
    func showWeekSchedule(placeID: Int) {
        self.serviceAPI.getScheduleOfPlace(completion: { result in
                switch result {
                case .success(let weekSchedule):
                    print(weekSchedule)
                    //self.times = times
                case .failure(let error):
                    print(error)
                //                                    DispatchQueue.main.async {
                //                                        viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
                //                                      }
                }
        }, placeIdentifier: placeID)
    }
    
}
