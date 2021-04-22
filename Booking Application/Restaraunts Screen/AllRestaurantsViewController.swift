//
//  AllRestarauntsViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI

class AllRestaurantsViewController: UIHostingController<AllRestaurantsView>  {
    private let state = AllRestaurantViewModel()
    var api = ServiceAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        api.fetchDataAboutPlaces()
        if api.places != nil {
            state.places = api.places!.data!
        }
    }
    
    init() {
        let view = AllRestaurantsView(allRestaurantsViewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backToMain() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
//        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//            let nextViewController = HomeViewController()
//            sceneDelegate.window?.rootViewController = nextViewController
//            sceneDelegate.window?.makeKeyAndVisible()
//        }
    }
    
    func redirectToRestarauntDetails(object: Place) {
        print(object)
        let rootviewController = DetailsRestarauntViewController()
        rootviewController.place = object
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
}
