//
//  HomeViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI

class HomeViewController: UIHostingController<HomeView>  {
    private let state = HomeViewModel()
    
    init() {
        let view = HomeView(homeViewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func seeAllRestaraunts() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {           
            let nextViewController = AllRestaurantsViewController()
            self.navigationController?.pushViewController(nextViewController, animated: true)
            sceneDelegate.window?.rootViewController = nextViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func seeAllCategories() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let nextViewController = AllCategoriesViewController()
            self.navigationController?.pushViewController(nextViewController, animated: true)
            sceneDelegate.window?.rootViewController = nextViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

}
