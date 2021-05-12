//
//  AllCategoriesViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import SwiftUI

class CategoriesViewController: UIHostingController<CategoriesView>  {
    private let viewModel = CategoriesViewModel()
    
    // MARK: -> Make Navigation Bar Hidden
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        viewModel.loadMoreContent()
    }
    
    // MARK: -> Initialization SwiftUI View
    
    init() {
        let view = CategoriesView(viewModel: viewModel)
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
    
    // MARK: -> Redirect User To Food Items of Category
    
    func redirectCategoryPlaces(categoryIdentifier: Int, categoryName: String) {
        let navigationController = UINavigationController(rootViewController: CategoryPlacesViewController(categoryIdentifier: categoryIdentifier, categoryName: categoryName))
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: -> Redirect User To Food Items of Category
    
    func redirectToFoodItems() {
        let navigationController = UINavigationController(rootViewController: FoodItemsViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
}
