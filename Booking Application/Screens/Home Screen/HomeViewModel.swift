//
//  HomeViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation
import CoreLocation

class HomeViewModel: ObservableObject {
    weak var controller: HomeViewController?
    private let serviceAPI: ServiceAPI = ServiceAPI()
    @Published var locationManager: CLLocationManager?
    
    @Published var addressFull: String?
    
    @Published var categories = [Category]()
    @Published var places = [Place]()
    @Published var favorites = [Place]()
    
    func deleteFavouriteState(place: Place) {
        self.serviceAPI.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                //place.favourite?.toggle()
                self.fetchFavourites()
                self.fetchPlaces()
                print(response)
            case .failure(let error):
                print(error)
            }
        }, placeIdentifier: place.id)
    }
    
    func setFavouriteState(place: Place) {
        self.serviceAPI.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                //place.favourite?.toggle()
                self.fetchFavourites()
                self.fetchPlaces()
                print(response)
            case .failure(let error):
                print(error)
            }
        }, placeIdentifier: place.id)
    }
    
    func fetchPlaces() {
        serviceAPI.fetchDataAboutPlaces(completion: { result in
            switch result {
            case .success(let places):
                self.places = places.data
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func fetchFavourites() {
        serviceAPI.fetchDataAboutFavourites(completion: { result in
            switch result {
            case .success(let favorites):
                self.favorites = favorites.data
                for (index, _) in self.favorites.enumerated() {
                    self.favorites[index].favourite = true
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func sentUserLocation() {
        getAddressFromLatLon(completion: { result in
            switch result {
            case .success(let address):
                self.addressFull = address
                self.serviceAPI.sentCurrentUserLocation(completion: { result in
                    switch result {
                    case .success(let message):
                        print(message)
                    case .failure(let error):
                        print(error)
                    }
                }, latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude"), address: address)
            case .failure(let error):
                print(error)
            }
        }, pdblLatitude: UserDefaults.standard.double(forKey: "latitude"), withLongitude: UserDefaults.standard.double(forKey: "longitude"))
        

    }
    
    func getAddressFromLatLon(completion: @escaping (Result<String, Error>) -> Void, pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude: pdblLatitude, longitude: pdblLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Reverse geodcode fail: \(error!.localizedDescription)")
                completion(.failure(error!))
            }
            
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                let address: String = (pm.country ?? "") + ", " + (pm.locality ?? "") //+ ", " + (pm.thoroughfare ?? "")
                completion(.success(address))
            }
        })
    }
    
}
