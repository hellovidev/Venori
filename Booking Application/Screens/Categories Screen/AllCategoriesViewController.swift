//
//  AllCategoriesViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI

class AllCategoriesViewController: UIHostingController<AllCategoriesView>  {
    private let state = AllCategoriesViewModel()
    var serviceAPI = ServiceAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
//        api.fetchDataAboutCategories()
//        if api.categories != nil {
//            state.categories = api.categories!.data
//        }
//        serviceAPI.fetchDataAboutCategories(completion: {
//            response in
//            self.state.categories = self.serviceAPI.categories!.data
//        })
    }
    
    init() {
        let view = AllCategoriesView(viewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redirectPrevious() {       
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: -> Pop Up for Faild Print
    
    func failPopUp(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
