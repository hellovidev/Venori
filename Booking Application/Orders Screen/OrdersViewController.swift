//
//  OrdersViewController.swift
//  Booking Application
//
//  Created by student on 16.04.21.
//

import UIKit
import SwiftUI

class OrdersViewController: UIHostingController<OrdersView>  {
    private let state = OrdersViewModel()
    
    init() {
        let view = OrdersView(ordersViewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
