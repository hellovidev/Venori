//
//  AllRestarauntsViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI

class PlacesViewController: UIHostingController<PlacesView>  {
    private let viewModel = PlacesViewModel()
    
    // MARK: -> Update Values
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        viewModel.places.removeAll()
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
        let view = PlacesView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Go To Previous Screen
    
    func redirectPrevious() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -> Redirect User To Place Details Screen
    
    func redirectPlaceDetails(object: Place) {
        let rootviewController = DetailsRestarauntViewController()
        rootviewController.place = object
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
}
