//
//  BookingHistoryViewController.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import SwiftUI

class BookingHistoryViewController: UIHostingController<BookingHistoryView>  {
    private let viewModel = BookingHistoryViewModel()
    
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
        let view = BookingHistoryView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Click On 'Back' Button
    
    func redirectPrevious() {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: -> Redirect User To Detail Information About Place
    
    func redirectPlaceDetails(object: Place) {
        let rootviewController = PlaceDetailsViewController(place: object)
        let navigationController = UINavigationController(rootViewController: rootviewController)
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false, completion: nil)
    }
    
}
