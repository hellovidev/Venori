//
//  UserMenuViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI

class MoreViewController: UIHostingController<MoreView>  {
    private let viewModel = MoreViewModel()
    
    // MARK: -> Make Navigation Bar Hidden
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: -> Make Status Bar Color Elements White
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: -> Initialization SwiftUI View

    init() {
        let view = MoreView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Log Out User
    
    func systemLogout() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let nextViewController = LoginViewController()
            sceneDelegate.window?.rootViewController = nextViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: -> Redirect User To Booking History Screen
    
    func redirectBookingHistory() {
        let navigationController = UINavigationController(rootViewController: BookingHistoryViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Redirect User To Favourites Screen
    
    func redirectFavourites() {
        let navigationController = UINavigationController(rootViewController: FavouritesViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
}
