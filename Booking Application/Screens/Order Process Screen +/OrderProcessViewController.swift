//
//  BookViewController.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import UIKit
import SwiftUI

class OrderProcessViewController: UIHostingController<OrderProcessView>  {
    private let viewModel = OrderProcessViewModel()
    var placeID: Int?
    
    // Hide Navigation Bar & Set Place ID to View Model From Place Details Screen
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        viewModel.placeID = placeID
    }
    
    init() {
        let view = OrderProcessView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Click on 'Back' Button on Order Process View
    
    func backToPlace() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -> Click on 'Continue' Button on Complete View
    
    func completeOrderProcess() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -> Pop Up for Faild Print
    
    func failPopUp(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
