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
        
        //***
        serviceAPI.fetchDataAboutCategories()
        if serviceAPI.categories != nil {
            state.categories = serviceAPI.categories!.data
        }
        serviceAPI.fetchDataAboutPlaces()
        if serviceAPI.places != nil {
            state.places = serviceAPI.places!.data!
        }
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

}
