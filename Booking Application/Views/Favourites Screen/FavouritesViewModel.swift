//
//  FavouritesViewModel.swift
//  Booking Application
//
//  Created by student on 6.05.21.
//

import Combine
import Foundation

class FavouritesViewModel: ObservableObject {
    weak var controller: FavouritesViewController?
    private var cancellables = Set<AnyCancellable>()
    private var serverRequest = ServerRequest()
    private var canLoadMorePages = true
    private var currentPage = 1
    
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    @Published var favourites = [Place]()
    @Published var isLoadingPage = false
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    init() {
        self.loadMoreFavourites()
        
        // Register to receive notification in your class
        
        NotificationCenter.default
            .publisher(for: .newFavouriteFromPlaceNotification)
            .sink() { [weak self] _ in
                
                // Handle notification
                
                self?.resetFavouritesData()
                self?.loadMoreFavourites()
            }
            .store(in: &cancellables)
    }
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Place?) {
        guard let item = item else {
            loadMoreFavourites()
            return
        }
        
        let thresholdIndex = favourites.index(favourites.endIndex, offsetBy: -4)
        if favourites.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreFavourites()
        }
    }
    
    func loadMoreFavourites() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
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
                self.canLoadMorePages = (response.lastPage != response.currentPage)
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Loading of favourites finished.")
                case .failure(let error):
                    print("Error of load favourites: \(error.localizedDescription)")
                    self.isLoadingPage = false
                    self.resetFavouritesData()
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print("Loaded some favourites: \(response.data.count)")
                self.favourites.append(contentsOf: response.data)
                
                for (index, _) in self.favourites.enumerated() {
                    self.favourites[index].favourite = true
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: -> API Request For Delete Place From Favourite
    
    func deleteFavouriteState(favourite: Place) {
        serverRequest.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                if let removeOrderIndex = self.favourites.firstIndex(where: { $0.id == favourite.id }) {
                    self.favourites.remove(at: removeOrderIndex)
                }
                
                // Post notification to favourite places
                
                NotificationCenter.default.post(name: .newFavouriteNotification, object: nil)
                print("Delete favourite success: \(response)")
            case .failure(let error):
                self.showAlert = true
                self.errorMessage = error.localizedDescription
                print("Delete favourite faild: \(error.localizedDescription)")
            }
        }, placeIdentifier: favourite.id)
    }
    
    func resetFavouritesData() {
        currentPage = 1
        isLoadingPage = false
        favourites.removeAll()
        canLoadMorePages = true
    }
    
}
