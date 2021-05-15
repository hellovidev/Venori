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
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    private var serverRequest = ServerRequest()
    var canLoadMorePages = true
    var currentPage = 1
    
    @Published var places = [Place]()
    @Published var isLoadingPage = false
    @Published var isProcessDelete = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Place?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = places.index(places.endIndex, offsetBy: -5)
        if places.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    func loadMoreContent() {
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
            .map({ response in
                print(response.data)
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
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
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
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        }, placeIdentifier: favourite.id)
    }
    
}
