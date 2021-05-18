//
//  CategoryPlacesViewModel.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import Combine
import SwiftUI

class CategoryPlacesViewModel: ObservableObject {
    weak var controller: CategoryPlacesViewController?
    private var serverRequest = ServerRequest()
    private var cancellables = Set<AnyCancellable>()
    private var canLoadMorePages = true
    private var currentPage = 1
    
    @Published var places = [Place]()
    @Published var isLoadingPage = false
    
    // Alert Data
    
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    // Identity Data
    
    private let categoryIdentifier: Int
    let categoryName: String
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    init(categoryIdentifier: Int, categoryName: String) {
        self.categoryIdentifier = categoryIdentifier
        self.categoryName = categoryName
        
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
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.categoriesRoute.rawValue + "/\(self.categoryIdentifier)/" + DomainRouter.placesRoute.rawValue)!
        
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
            .map({ response in
                //print(response.data)
                self.places.append(contentsOf: response.data)
                return self.places
            })
            .catch({ _ in Just(self.places) })
            .assign(to: &$places)
    }
    
    // MARK: -> API Request For Delete Place From Favourite
    
    func deleteFavouriteState(favourite: Place) {
        serverRequest.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                if let deleteFavouriteIndex = self.places.firstIndex(where: { $0.id == favourite.id }) {
                    self.places[deleteFavouriteIndex].favourite = false
                }
                NotificationCenter.default.post(name: .newFavouriteNotification, object: nil)
                print("Delete favourite success: \(response)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print("Delete favourite faild: \(error.localizedDescription)")
            }
        }, placeIdentifier: favourite.id)
    }
    
    // MARK: -> API Request For Add Place To Favourite
    
    func setFavouriteState(favourite: Place) {
        self.serverRequest.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let setFavouriteIndex = self.places.firstIndex(where: { $0.id == favourite.id }) {
                        self.places[setFavouriteIndex].favourite = true
                    }
                    NotificationCenter.default.post(name: .newFavouriteNotification, object: nil)
                    print("Make favourite success: \(response.name) now is favourite.")
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print("Make favourite faild: \(error.localizedDescription)")
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
