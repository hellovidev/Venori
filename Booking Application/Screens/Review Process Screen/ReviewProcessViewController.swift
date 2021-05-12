//
//  ReviewProcessViewController.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import SwiftUI

class ReviewProcessViewController: UIHostingController<ReviewProcessView>  {
    private let viewModel: ReviewProcessViewModel
    
    // MARK: -> Update Values
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    // MARK: -> Make Navigation Bar Hidden
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: -> Initialization SwiftUI View
    
    init(placeIdentifier: Int) {
        viewModel = ReviewProcessViewModel(placeIdentifier: placeIdentifier)
        let view = ReviewProcessView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Click On 'Back' Button
    
    func redirectPrevious() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
