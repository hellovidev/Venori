//
//  OrdersViewController.swift
//  Booking Application
//
//  Created by student on 16.04.21.
//

import UIKit
import SwiftUI

class OrdersViewController: UIHostingController<OrdersView>  {
    private let viewModel = OrdersViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    init() {
        let view = OrdersView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
