//
//  AllRestarauntsViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Combine
import Foundation

class PlacesViewModel: ObservableObject {
    weak var controller: PlacesViewController?
    private var cancellables = Set<AnyCancellable>()
    private var serverRequest = ServerRequest()
    private var canLoadMorePages = true
    private var currentPage = 1
    
    @Published var places = [Place]()
    @Published var isLoadingPage = false
    
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    init() {
        self.loadMorePlaces()
        
        // Register to receive notification in your class
        
        NotificationCenter.default
            .publisher(for: .newFavouriteFromPlaceNotification)
            .sink() { [weak self] _ in
                
                // Handle notification
                
                self?.resetPlacesData()
                self?.loadMorePlaces()
            }
            .store(in: &cancellables)
    }
    
    
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Place?) {
        guard let item = item else {
            loadMorePlaces()
            return
        }
        
        let thresholdIndex = places.index(places.endIndex, offsetBy: -5)
        if places.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMorePlaces()
        }
    }
    
    func loadMorePlaces() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
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
                self.canLoadMorePages = (response.lastPage != response.currentPage)
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Loading of places finished.")
                case .failure(let error):
                    print("Error of load places: \(error.localizedDescription)")
                    self.isLoadingPage = false
                    self.resetPlacesData()
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print("Loaded some places: \(response.data.count)")
                self.places.append(contentsOf: response.data)
            })
            .store(in: &cancellables)
    }
    
    // MARK: -> API Request For Delete Place From Favourite
    
    func deleteFavouriteState(favourite: Place) {
        serverRequest.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                if let deleteFavouriteIndex = self.places.firstIndex(where: { $0.id == favourite.id }) {
                    self.places[deleteFavouriteIndex].favourite = false
                }
                
                // Post notification to favourite places
                
                NotificationCenter.default.post(name: .newFavouriteNotification, object: nil)
                print("Delete favourite success: \(response)")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Delete favourite faild: \(error.localizedDescription)")
                }
            }
        }, placeIdentifier: favourite.id)
    }
    
    // MARK: -> API Request For Add Place To Favourite
    
    func setFavouriteState(favourite: Place) {
        self.serverRequest.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                if let setFavouriteIndex = self.places.firstIndex(where: { $0.id == favourite.id }) {
                    self.places[setFavouriteIndex].favourite = true
                }
                
                // Post notification to favourite places
                
                NotificationCenter.default.post(name: .newFavouriteNotification, object: nil)
                print("Add favourite success: \(response)")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Add favourite faild: \(error.localizedDescription)")
                }
            }
        }, placeIdentifier: favourite.id)
    }
    
    func resetPlacesData() {
        currentPage = 1
        places.removeAll()
        isLoadingPage = false
        canLoadMorePages = true
    }
    
}
