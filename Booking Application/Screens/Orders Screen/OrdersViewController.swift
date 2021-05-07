//
//  OrdersViewController.swift
//  Booking Application
//
//  Created by student on 16.04.21.
//

import SwiftUI

class OrdersViewController: UIHostingController<OrdersView>  {
    private let viewModel = OrdersViewModel()
    
    // MARK: -> Update Values
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        viewModel.orders.removeAll()
        viewModel.isLoadingPage = false
        viewModel.canLoadMorePages = true
        viewModel.currentPage = 1
    }
    
    // MARK: -> Make Navigation Bar Hidden
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        viewModel.loadMoreContent()
    }
    
    // MARK: -> Initialization SwiftUI View
    
    init() {
        let view = OrdersView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
