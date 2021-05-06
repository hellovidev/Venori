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
    private var canLoadMorePages = true
    private var currentPage = 1
    
    @Published var orders = [Order]()
    @Published var isLoadingPage = false
    @Published var isProcessDelete = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: -> Load Content By Pages
    
    init() {
        loadMoreContent()
    }
    
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
    
    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.ordersRoute.rawValue)!
        
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
    
    //Template
    @Published var place = Place()
    
    func fetchPlaceOfOrder(placeIdentifier: Int) {
        self.serviceAPI.getPlaceByIdentifier(completion: { response in
            switch response {
            case .success(let place):
                self.place = place
            case .failure(let error):
                print("PlaceInnerItemView has error: \(error)")
            }
        }, placeIdentifier: placeIdentifier)
    }
    
}


//private enum StatusOrder {
//    case Available
//    case Process
//    case Deleted
//}
//
//
//
//@Published var isError: Bool = false
//@Published var isEmpty: Bool = false
//
//@Published var statusOrder = StatusOrder.Available
//
//func fetchOrders() {
//    self.serviceAPI.fetchDataAboutOrders(completion: { result in
//        switch result {
//        case .success(let orders):
//            self.orders = orders.data
//            self.isLoadingPage = false
//            self.isError = false
//            
//            guard self.orders?.isEmpty != nil else {
//                self.isEmpty = true
//                return
//            }
//            
//            if self.orders!.isEmpty {
//                self.isEmpty = true
//            } else {
//                self.isEmpty = false
//            }
//        case .failure(let error):
//            self.isLoadingPage = false
//            self.isError = true
//            self.isEmpty = false
//
//            guard self.orders?.isEmpty != nil else {
//                return
//            }
//            
//            if !self.orders!.isEmpty {
//                self.orders?.removeAll()
//            }
//            
//            print(error)
//        }
//    })
//}
