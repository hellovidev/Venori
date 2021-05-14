//
//  OrdersViewModel.swift
//  Booking Application
//
//  Created by student on 16.04.21.
//

import Combine
import SwiftUI
import Foundation

class OrdersViewModel: ObservableObject {
    weak var controller: OrdersViewController?
    private let serviceAPI = ServiceAPI()
    var canLoadMorePages = true
    var currentPage = 1
    
    @Published var orders = [Order]()
    @Published var isLoadingPage = false
    @Published var isProcessDelete = false
    
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Order?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = orders.index(orders.endIndex, offsetBy: -5)
        if orders.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    func loadMoreContent() {
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
        print(url.url!)
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
            .map({ response in
                print(response.data)
                self.orders.append(contentsOf: response.data)
                
                return self.orders
            })
            .catch({ _ in Just(self.orders) })
            .assign(to: &$orders)
    }
    
    // MARK: -> Cancel Order
    
    func cancelOrder(orderIdentifier: Int) {
        self.serviceAPI.cancelOrderInProgress(completion: { result in
            switch result {
            case .success(let message):
                if let removeOrderIndex = self.orders.firstIndex(where: { $0.id == orderIdentifier }) {
                    self.orders.remove(at: removeOrderIndex)
                }
                print(message)
            case .failure(let error):
                print(error)
            }
        }, orderIdentifier: orderIdentifier)
    }
    
}
