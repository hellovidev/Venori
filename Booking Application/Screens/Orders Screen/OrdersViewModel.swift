//
//  OrdersViewModel.swift
//  Booking Application
//
//  Created by student on 16.04.21.
//

import UIKit
import SwiftUI
import Foundation

class OrdersViewModel: ObservableObject {
    weak var controller: OrdersViewController?
    private let serviceAPI = ServiceAPI()
    
    @Published var orders: [Order]?
    @Published var isError: Bool = false
    @Published var isEmpty: Bool = false
    @Published var isLoading: Bool = true
    
    @Published var statusOrder = StatusOrder.Available
    
    func fetchOrders() {
        self.serviceAPI.fetchDataAboutOrders(completion: { result in
            switch result {
            case .success(let orders):
                self.orders = orders.data
                self.isLoading = false
                self.isError = false
                guard self.orders?.isEmpty != nil else {
                    self.isEmpty = true
                    return
                }
                
                if self.orders?.isEmpty ?? true && self.orders?.isEmpty != nil {
                    self.isEmpty = true
                } else {
                    self.isEmpty = false
                }
            case .failure(let error):
                self.isLoading = false
                self.isEmpty = false
                self.isError = true
                print(error)
            }
        })
    }
    
    func cancelOrder(orderIdentifier: Int) {
        self.serviceAPI.cancelOrderInProgress(completion: { result in
            switch result {
            case .success(let message):                
                if let removeOrderIndex = self.orders?.firstIndex(where: { $0.id == orderIdentifier }) {
                    self.orders?.remove(at: removeOrderIndex)
                }
                Alert(title: Text("Complete"), message: Text(message), dismissButton: .cancel())
                print(message)
            case .failure(let error):
                print(error)
            }
        }, orderIdentifier: orderIdentifier)
    }
}

enum StatusOrder {
    case Available
    case Process
    case Deleted
}

