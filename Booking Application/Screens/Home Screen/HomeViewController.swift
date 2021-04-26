//
//  HomeViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI
import Combine

class HomeViewController: UIHostingController<HomeView>  {
    private let state = HomeViewModel()
    private var cancellable: AnyCancellable?
    private var serviceAPI = ServiceAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        //USAGE:

    //    getFriendIds(completion:{
    //        array in
    //        print(array) // Or do something else with the result
    //    })
//        serviceAPI.fetchDataAboutCategories(completion: { result in
//            switch result {
//            case .success(let categories):
//                self.state.categories = categories.data
//            case .failure(let error):
//                //self.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
//                print(error)
//                //print(error.localizedDescription)
//            }
//            
//            //self.state.categories = self.serviceAPI.categories!.data
//        })
        
        serviceAPI.fetchDataAboutPlaces(completion: {
            response in
            self.state.places = self.serviceAPI.places!.data!
        })
        
        
        //***
//        serviceAPI.fetchDataAboutCategories()
//        if serviceAPI.categories != nil {
//            state.categories = serviceAPI.categories!.data
//        }
//        serviceAPI.fetchDataAboutPlaces()
//        if serviceAPI.places != nil {
//            state.places = serviceAPI.places!.data!
//        }
    }
    
    override func viewDidLoad() {
        //cancellable?.cancel()
    }
    
    init() {
        let view = HomeView(viewModel: state)
        super.init(rootView: view)
        //cancellable = api.loadData().sink(receiveCompletion: {_ in}, receiveValue: { items in self.state.categories = items })
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -> Redirect User To Detail Information About Place

    func redirectToPlaceDetails(object: Place) {
        let rootviewController = DetailsRestarauntViewController()
        rootviewController.place = object
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> See All Functions
    
    func seeAllPlaces() {
        let navigationController = UINavigationController(rootViewController: PlacesViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    func seeAllCategories() {
        let navigationController = UINavigationController(rootViewController: AllCategoriesViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }

    // MARK: -> Pop Up for Faild Print
    
    func failPopUp(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
