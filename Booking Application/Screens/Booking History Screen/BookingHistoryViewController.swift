//
//  BookingHistoryViewController.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import UIKit
import SwiftUI

class BookingHistoryViewController: UIHostingController<BookingHistoryView>  {
    private let viewModel = BookingHistoryViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    init() {
        let view = BookingHistoryView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redirectPrevious() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
