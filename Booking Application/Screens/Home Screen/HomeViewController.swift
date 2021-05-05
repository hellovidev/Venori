//
//  HomeViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI
import Combine
import CoreLocation

class HomeViewController: UIHostingController<HomeView>, CLLocationManagerDelegate  {
    private let viewModel = HomeViewModel()
    private var cancellable: AnyCancellable?
    private var serviceAPI = ServiceAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.locationManager = CLLocationManager()
        viewModel.locationManager?.delegate = self
        viewModel.locationManager?.requestAlwaysAuthorization()
        view.backgroundColor = .gray
    }
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //cancellable?.cancel()
//    }
    
    init() {
        let view = HomeView(viewModel: viewModel)
        super.init(rootView: view)
        //cancellable = api.loadData().sink(receiveCompletion: {_ in}, receiveValue: { items in self.state.categories = items })
        viewModel.controller = self
    }
    
    // MARK: -> User Location
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
                    print("locations = \(locValue.latitude) \(locValue.longitude)")
                    UserDefaults.standard.set(locValue.latitude, forKey: "latitude")
                    UserDefaults.standard.set(locValue.longitude, forKey: "longitude")
                    UserDefaults.standard.synchronize()
                    
                    self.viewModel.sentUserLocation()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
        }
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
    
    func redirectToFoodItems() {
        let navigationController = UINavigationController(rootViewController: FoodItemsViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    func showMapView() {
        let navigationController = UINavigationController(rootViewController: MapViewController(latitude: UserDefaults.standard.double(forKey: "latitude") , longitude: UserDefaults.standard.double(forKey: "longitude") ))
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
}
