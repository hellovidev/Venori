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
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    private var serviceAPI = ServerRequest()
    var canLoadMorePages = true
    var currentPage = 1
    
    @Published var favourites = [Place]()
    @Published var isLoadingPage = false
    @Published var isProcessDelete = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Place?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = favourites.index(favourites.endIndex, offsetBy: -5)
        if favourites.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    func loadMoreContent() {
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
            .map({ response in
                print(response.data)
                self.favourites.append(contentsOf: response.data)
                
                for (index, _) in self.favourites.enumerated() {
                    self.favourites[index].favourite = true
                }
                
                return self.favourites
            })
            .catch({ _ in Just(self.favourites) })
            .assign(to: &$favourites)
    }
    
    // MARK: -> API Request For Delete Place From Favourite
    
    func deleteFavouriteState(favourite: Place) {
        serviceAPI.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                if let removeOrderIndex = self.favourites.firstIndex(where: { $0.id == favourite.id }) {
                    self.favourites.remove(at: removeOrderIndex)
                }
                self.isProcessDelete = false
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        }, placeIdentifier: favourite.id)
    }
    
}
