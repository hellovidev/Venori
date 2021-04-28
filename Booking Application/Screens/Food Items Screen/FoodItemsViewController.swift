//
//  FoodItemsViewController.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import UIKit
import SwiftUI

class FoodItemsViewController: UIHostingController<FoodItemsView>  {
    private let viewModel = FoodItemsViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    init() {
        let view = FoodItemsView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Click On 'Back' Button
    
    func goBackToPreviousView() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
