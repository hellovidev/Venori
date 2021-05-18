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
    
    // MARK: -> Make Navigation Bar Hidden
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: -> Redirect User To Detail Information About Place
    
    func redirectPlaceDetails(object: Place) {
        let rootviewController = PlaceDetailsViewController(place: object)
        let navigationController = UINavigationController(rootViewController: rootviewController)
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false, completion: nil)
    }
    
    // MARK: -> Redirect User To Category Places
    
    func redirectCategoryPlaces(categoryIdentifier: Int, categoryName: String) {
        let navigationController = UINavigationController(rootViewController: CategoryPlacesViewController(categoryIdentifier: categoryIdentifier, categoryName: categoryName))
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false, completion: nil)
    }
    
    // MARK: -> Show Map View
    
    func showMapView() {
        if viewModel.addressFull != nil {
            let navigationController = UINavigationController(rootViewController: MapViewController(latitude: UserDefaults.standard.double(forKey: "latitude") , longitude: UserDefaults.standard.double(forKey: "longitude") ))
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        } else {
            viewModel.locationManager = CLLocationManager()
            viewModel.locationManager?.delegate = self
            viewModel.locationManager?.requestAlwaysAuthorization()
            view.backgroundColor = .gray
        }
    }
    
    // MARK: -> See All Functions
    
    func seeAllPlaces() {
        let navigationController = UINavigationController(rootViewController: PlacesViewController())
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false, completion: nil)
    }
    
    func seeAllCategories() {
        let navigationController = UINavigationController(rootViewController: CategoriesViewController())
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false, completion: nil)
    }
    
    func seeAllFavourites() {
        let navigationController = UINavigationController(rootViewController: FavouritesViewController())
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false, completion: nil)
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
