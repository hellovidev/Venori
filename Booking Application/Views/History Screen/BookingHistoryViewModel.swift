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
    private var serviceAPI = ServerRequest()
    var canLoadMorePages = true
    var currentPage = 1
    
    @Published var orders = [Order]()
    @Published var isLoadingPage = false
    @Published var isProcessDelete = false
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Order?) {
        guard let item = item else {
            self.loadMoreContent()
            return
        }
        
        let thresholdIndex = orders.index(orders.endIndex, offsetBy: -5)
        if orders.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            self.loadMoreContent()
        }
    }
    
    func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.ordersRoute.rawValue)!

        url.queryItems = [
            URLQueryItem(name: "history", value: nil),
            URLQueryItem(name: "page", value: "\(self.currentPage)")
        ]
           // ?history=""&page=3
        
//        let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.bookingHistoryRoute.rawValue + "&page=\(self.currentPage)")!
        
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
//            .sink(receiveCompletion: { error in
//                print(error)
//
//            }, receiveValue: { response in
//                print(response.data)
//                self.orders.append(contentsOf: response.data)
//                //return self.orders
//            })
            .map({ response in
                print(response.data)
                self.orders.append(contentsOf: response.data)
                return self.orders
            })
            //.replaceError(with: [])
            .catch({ _ in Just(self.orders) })
            .assign(to: &$orders)
    }
    
}
