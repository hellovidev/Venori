//
//  HomeViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Combine
import Foundation
import CoreLocation

class HomeViewModel: ObservableObject {
    weak var controller: HomeViewController?
    private let serviceAPI: ServiceAPI = ServiceAPI()
    @Published var locationManager: CLLocationManager?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var addressFull: String?
    
    @Published var categories = [Category]()
    @Published var favorites = [Place]()
    @Published var places = [Place]()

    @Published var isLoadingPage = false
    private var currentPage = 1

    @Published var showAlertError = false
    @Published var errorMessage = ""

     func loadPlacesContent() {
//        guard !isLoadingPage else {
//            return
//        }
//
//        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue)!
        
        url.queryItems = [
            URLQueryItem(name: "page", value: "\(self.currentPage)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map(\.data)
            .decode(type: Places.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.isLoadingPage = false
            })
            .map({ response in
                print(response.data)
                self.places = response.data
                return self.places
            })
            .catch({ _ in Just(self.places) })
            .assign(to: &$places)
    }
    
     func loadFavouritesContent() {
//        guard !isLoadingPage else {
//            return
//        }
//
//        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.favouritesRoute.rawValue)!
        
        url.queryItems = [
            URLQueryItem(name: "page", value: "\(self.currentPage)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map(\.data)
            .decode(type: Places.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.isLoadingPage = false
            })
            .map({ response in
                print(response.data)
                self.favorites = response.data
                
                for (index, _) in self.favorites.enumerated() {
                    self.favorites[index].favourite = true
                }
                
                return self.favorites
            })
            .catch({ _ in Just(self.favorites) })
            .assign(to: &$favorites)
    }
    
    func loadCategoriesContent() {
//        guard !isLoadingPage else {
//            return
//        }
//
//        isLoadingPage = true
       
       var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.categoriesRoute.rawValue)!
       
       url.queryItems = [
           URLQueryItem(name: "page", value: "\(self.currentPage)")
       ]
       
       var request = URLRequest(url: url.url!)
       request.httpMethod = "GET"
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       request.setValue("application/json", forHTTPHeaderField: "Accept")
       
       request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
       
       URLSession.shared.dataTaskPublisher(for: request as URLRequest)
           .map(\.data)
           .decode(type: Categories.self, decoder: JSONDecoder())
           .receive(on: DispatchQueue.main)
           .handleEvents(receiveOutput: { response in
               self.isLoadingPage = false
           })
           .map({ response in
               print(response.data)
               self.categories = response.data
               
               return self.categories
           })
           .catch({ _ in Just(self.categories) })
           .assign(to: &$categories)
   }
    
    func deleteFavouriteState(place: Place) {
        self.serviceAPI.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                //place.favourite?.toggle()
                
                self.loadPlacesContent()
                self.loadFavouritesContent()
                //self.fetchFavourites()
                //self.fetchPlaces()
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        }, placeIdentifier: place.id)
    }
    
    func setFavouriteState(place: Place) {
        self.serviceAPI.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                //place.favourite?.toggle()
                self.loadPlacesContent()
                self.loadFavouritesContent()

                //self.fetchFavourites()
                //self.fetchPlaces()
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        }, placeIdentifier: place.id)
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
                        self.errorMessage = error.localizedDescription
                        self.showAlertError = true
                        print(error)
                    }
                }, latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude"), address: address)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
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
            
            guard placemarks != nil else {
                completion(.failure(error!))
                return
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
