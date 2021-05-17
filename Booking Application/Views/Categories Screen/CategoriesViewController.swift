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
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: -> Redirect User To Food Items of Category
    
    func redirectCategoryPlaces(categoryIdentifier: Int, categoryName: String) {
        let navigationController = UINavigationController(rootViewController: CategoryPlacesViewController(categoryIdentifier: categoryIdentifier, categoryName: categoryName))
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false, completion: nil)
    }
    
}
