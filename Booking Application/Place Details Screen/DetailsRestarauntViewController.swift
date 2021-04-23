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
        let navigationController = UINavigationController(rootViewController: BookViewController())
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
        let rootviewController = BookViewController()
        rootviewController.placeID = object.id
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
}
