//
//  ReviewsViewController.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import SwiftUI

class ReviewsViewController: UIHostingController<ReviewsView>  {
    private let viewModel: ReviewsViewModel
    
    // MARK: -> Update Values
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        viewModel.reviews.removeAll()
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
    
    init(placeIdentifier: Int) {
        viewModel = ReviewsViewModel(placeIdentifier: placeIdentifier)
        let view = ReviewsView(viewModel: viewModel)
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
    
    // MARK: -> Redirect User To New Review

    func redirectNewReview(placeIdentifier: Int) {
        let rootviewController = ReviewProcessViewController(placeIdentifier: placeIdentifier)
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .popover
        self.present(navigationController, animated: true, completion: nil)
    }
    
}
