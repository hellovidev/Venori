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
    var api = ServiceAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        api.fetchDataAboutCategories()
        if api.categories != nil {
            state.categories = api.categories!.data
        }
    }
    
    init() {
        let view = AllCategoriesView(allCategoriesViewModel: state)
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

}
