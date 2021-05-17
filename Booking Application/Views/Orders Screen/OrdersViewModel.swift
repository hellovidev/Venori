//
//  OrdersViewModel.swift
//  Booking Application
//
//  Created by student on 16.04.21.
//

import Combine
import SwiftUI

class OrdersViewModel: ObservableObject {
    weak var controller: OrdersViewController?
    private var cancellables = Set<AnyCancellable>()
    private let serverRequest = ServerRequest()
    private var canLoadMorePages = true
    private var currentPage = 1
    
    @Published var activeOrders = [Order]()
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
        self.loadMoreActiveOrders()
        
        // Register to receive notification in your class
        
        NotificationCenter.default
            .publisher(for: .newOrderNotification)
            .sink() { [weak self] _ in
                
                // Handle notification
                
                self?.resetActiveOrders()
                self?.loadMoreActiveOrders()
            }
            .store(in: &cancellables)
    }
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Order?) {
        guard let item = item else {
            loadMoreActiveOrders()
            return
        }
        
        let thresholdIndex = activeOrders.index(activeOrders.endIndex, offsetBy: -3)
        if activeOrders.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreActiveOrders()
        }
    }
    
    func loadMoreActiveOrders() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.ordersRoute.rawValue)!

        url.queryItems = [
            URLQueryItem(name: "active", value: nil),
            URLQueryItem(name: "page", value: "\(self.currentPage)")
        ]
        
        var request = URLRequest(url: url.url!)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map(\.data)
            .decode(type: Orders.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.canLoadMorePages = (response.lastPage != response.currentPage)
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Loading of active orders finished.")
                case .failure(let error):
                    print("Error of load active orders: \(error.localizedDescription)")
                    self.isLoadingPage = false
                    self.resetActiveOrders()
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print("Loaded some active orders: \(response.data.count)")
                self.activeOrders.append(contentsOf: response.data)
            })
            .store(in: &cancellables)
    }
    
    // MARK: -> Cancel Order
    
    func cancelOrder(orderIdentifier: Int) {
        self.serverRequest.cancelOrderInProgress(completion: { result in
            switch result {
            case .success(let message):
                if let removeOrderIndex = self.activeOrders.firstIndex(where: { $0.id == orderIdentifier }) {
                    self.activeOrders.remove(at: removeOrderIndex)
                }
                // Post notification to history orders
                NotificationCenter.default.post(name: .newOrderHistoryNotification, object: nil)
                print("Cancel order success: \(message)")
            case .failure(let error):
                self.showAlert = true
                self.errorMessage = error.localizedDescription
                print("Cancel order faild: \(error.localizedDescription)")
            }
        }, orderIdentifier: orderIdentifier)
    }
    
    func resetActiveOrders() {
        currentPage = 1
        activeOrders.removeAll()
        isLoadingPage = false
        canLoadMorePages = true
    }
    
}
