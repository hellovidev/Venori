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
    private let serverRequest = ServerRequest()
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1

    @Published var locationManager: CLLocationManager?
    @Published var addressFull: String?
    @Published var categories = [Category]()
    @Published var favourites = [Place]()
    @Published var places = [Place]()
        
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    init() {
        self.loadPlacesContent()
        self.loadFavouritesContent()
        self.loadCategoriesContent()
        
        self.addressFull = UserDefaults.standard.string(forKey: "address_full")
        
        NotificationCenter.default
            .publisher(for: .newLocationNotification)
            .sink() { [weak self] _ in
                
                // Handle notification
                
                self?.addressFull = UserDefaults.standard.string(forKey: "address_full")
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .newLocationErrorNotification)
            .sink() { [weak self] _ in
                
                // Handle notification
                
                self?.showAlert = true
                self?.errorMessage = "Location doesn't loaded."
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .newFavouriteNotification)
            .sink() { [weak self] _ in
                
                // Handle notification
                
                self?.loadPlacesContent()
                self?.loadFavouritesContent()
                self?.loadCategoriesContent()
            }
            .store(in: &cancellables)
    }
    
    func loadPlacesContent() {
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
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Loading of places finished.")
                case .failure(let error):
                    print("Error of load places: \(error.localizedDescription)")
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print("Loaded some places: \(response.data.count)")
                self.places = response.data
            })
            .store(in: &cancellables)
    }
    
    func loadFavouritesContent() {
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
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Loading of favourites finished.")
                case .failure(let error):
                    print("Error of load favourites: \(error.localizedDescription)")
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print("Loaded some favourites: \(response.data.count)")
                self.favourites = response.data
                for (index, _) in self.favourites.enumerated() {
                    self.favourites[index].favourite = true
                }
            })
            .store(in: &cancellables)
    }
    
    func loadCategoriesContent() {
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
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Loading of сategories finished.")
                case .failure(let error):
                    print("Error of load сategories: \(error.localizedDescription)")
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print("Loaded some сategories: \(response.data.count)")
                self.categories = response.data
            })
            .store(in: &cancellables)
    }
    
    func deleteFavouriteState(place: Place) {
        self.serverRequest.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                if let deleteFavouriteIndex = self.places.firstIndex(where: { $0.id == place.id }) {
                    self.places[deleteFavouriteIndex].favourite = false
                }
                if let removeOrderIndex = self.favourites.firstIndex(where: { $0.id == place.id }) {
                    self.favourites.remove(at: removeOrderIndex)
                }
                print("Delete favourite success: \(response)")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Delete favourite faild: \(error.localizedDescription)")
                }
            }
        }, placeIdentifier: place.id)
    }
    
    func setFavouriteState(place: Place) {
        self.serverRequest.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                if let setFavouriteIndex = self.places.firstIndex(where: { $0.id == place.id }) {
                    self.places[setFavouriteIndex].favourite = true
                }
                self.loadFavouritesContent()
                print("Add favourite success: \(response)")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Add favourite faild: \(error.localizedDescription)")
                }
            }
        }, placeIdentifier: place.id)
    }
    
    func sentUserLocation() {
        getAddressFromLatLon(completion: { result in
            switch result {
            case .success(let address):
                self.addressFull = address
                self.serverRequest.sentCurrentUserLocation(completion: { result in
                    switch result {
                    case .success(let message):
                        print("Sent user location success: \(message)")
                    case .failure(let error):
                        
                        // Post notification about error location
                        
                        NotificationCenter.default.post(name: .newLocationErrorNotification, object: nil)
                        print("Sent user location faild: \(error.localizedDescription)")
                    }
                }, latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude"), address: address)
            case .failure(let error):
                
                // Post notification about error location
                
                NotificationCenter.default.post(name: .newLocationErrorNotification, object: nil)
                print("Sent user location faild: \(error.localizedDescription)")
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
            
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                let address: String = (placemark.country ?? "") // Some args more: + ", " + (placemark.locality ?? "") + ", " + (placemark.thoroughfare ?? "")
                UserDefaults.standard.set(address, forKey: "address_full")
                
                // Post notification about location data update
                
                NotificationCenter.default.post(name: .newLocationNotification, object: nil)
                completion(.success(address))
            }
        })
    }
    
    // MARK: -> Search Process
    
    @Published var placesSearch = [Place]()
    @Published var isLoadingPage = false
    
    private var canLoadMorePages = true
    private var currentPageSearch = 1
    
    func loadMoreContentIfNeeded(currentItem item: Place?) {
        guard let item = item else {
            loadMoreSearchPlaces()
            return
        }
        
        let thresholdIndex = placesSearch.index(placesSearch.endIndex, offsetBy: -5)
        if placesSearch.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreSearchPlaces()
        }
    }
    
    func loadMoreSearchPlaces() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue)!
        
        url.queryItems = [
            URLQueryItem(name: "page", value: "\(self.currentPageSearch)")
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
                self.canLoadMorePages = (response.lastPage != response.currentPage)
                self.isLoadingPage = false
                self.currentPageSearch += 1
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Loading of сategories finished.")
                case .failure(let error):
                    print("Error of load сategories: \(error.localizedDescription)")
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print("Loaded some сategories: \(response.data.count)")
                self.placesSearch.append(contentsOf: response.data)
            })
            .store(in: &cancellables)
    }
    
}
