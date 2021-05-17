//
//  BookingHistoryViewModel.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import Combine
import SwiftUI

class BookingHistoryViewModel: ObservableObject {
    weak var controller: BookingHistoryViewController?
    private var cancellables = Set<AnyCancellable>()
    private var serverRequest = ServerRequest()
    private var canLoadMorePages = true
    private var currentPage = 1
    
    @Published var historyOrders = [Order]()
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
        self.loadMoreHistoryOrders()
        
        // Register to receive notification in your class
        
        NotificationCenter.default
            .publisher(for: .newOrderHistoryNotification)
            .sink() { [weak self] _ in
                
                // Handle notification
                
                self?.resetOrdersHistoryData()
                self?.loadMoreHistoryOrders()
            }
            .store(in: &cancellables)
    }
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Order?) {
        guard let item = item else {
            self.loadMoreHistoryOrders()
            return
        }
        
        let thresholdIndex = historyOrders.index(historyOrders.endIndex, offsetBy: -5)
        if historyOrders.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            self.loadMoreHistoryOrders()
        }
    }
    
    func loadMoreHistoryOrders() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.ordersRoute.rawValue)!

        url.queryItems = [
            URLQueryItem(name: "history", value: nil),
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
                    print("Loading of history orders finished.")
                case .failure(let error):
                    print("Error of load history orders: \(error.localizedDescription)")
                    self.isLoadingPage = false
                    self.resetOrdersHistoryData()
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print("Loaded some history orders: \(response.data.count)")
                self.historyOrders.append(contentsOf: response.data)
            })
            .store(in: &cancellables)
    }
    
    func resetOrdersHistoryData() {
        currentPage = 1
        historyOrders.removeAll()
        isLoadingPage = false
        canLoadMorePages = true
    }
    
}
