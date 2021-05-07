//
//  HomeViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import SwiftUI
import CoreLocation

class HomeViewController: UIHostingController<HomeView>, CLLocationManagerDelegate  {
    private let viewModel = HomeViewModel()
    
    // MARK: -> Initialization SwiftUI View
    
    init() {
        let view = HomeView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Request User Location
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.locationManager = CLLocationManager()
        viewModel.locationManager?.delegate = self
        viewModel.locationManager?.requestAlwaysAuthorization()
        view.backgroundColor = .gray
    }
    
    // MARK: -> Make Navigation Bar Hidden
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        viewModel.loadPlacesContent()
        viewModel.loadFavouritesContent()
        viewModel.loadCategoriesContent()
    }
    
    // MARK: -> Redirect User To Detail Information About Place
    
    func redirectPlaceDetails(object: Place) {
        let rootviewController = DetailsRestarauntViewController()
        rootviewController.place = object
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Redirect User To Category Places
    
    func redirectCategoryPlaces(object: Category) {
//        let rootviewController = DetailsRestarauntViewController()
//        rootviewController.place = object
//        let navigationController = UINavigationController(rootViewController: rootviewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Redirect To Menu
    
    func redirectToFoodItems() {
        let navigationController = UINavigationController(rootViewController: FoodItemsViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Show Map View
    
    func showMapView() {
        let navigationController = UINavigationController(rootViewController: MapViewController(latitude: UserDefaults.standard.double(forKey: "latitude") , longitude: UserDefaults.standard.double(forKey: "longitude") ))
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
        let navigationController = UINavigationController(rootViewController: CategoriesViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    func seeAllFavourites() {
        let navigationController = UINavigationController(rootViewController: FavouritesViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> User Location
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
                    UserDefaults.standard.set(locationValue.latitude, forKey: "latitude")
                    UserDefaults.standard.set(locationValue.longitude, forKey: "longitude")
                    UserDefaults.standard.synchronize()
                    self.viewModel.sentUserLocation()
                    print("locations = \(locationValue.latitude) \(locationValue.longitude)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
        }
    }
    
}
