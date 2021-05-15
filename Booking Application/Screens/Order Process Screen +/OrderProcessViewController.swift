//
//  BookViewController.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import SwiftUI

class OrderProcessViewController: UIHostingController<OrderProcessView>  {
    private let viewModel: OrderProcessViewModel
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    init(placeIdentifier: Int) {
        viewModel = OrderProcessViewModel(placeIdentifier: placeIdentifier)
        let view = OrderProcessView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Click on 'Back' Button on Order Process View
    
    func redirectPrevious() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -> Click on 'Continue' Button on Complete View
    
    func completeOrderProcess() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
