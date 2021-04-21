//
//  LoginViewController.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import UIKit
import SwiftUI

class LoginViewController: UIHostingController<LoginView>  {
    private let state = LoginViewModel()
    
    init() {
        let view = LoginView(loginViewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redirectToSignUp() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let nextViewController = RegistrationViewController()
            sceneDelegate.window?.rootViewController = nextViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func processSignIn() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let nextViewController = HomeViewController()
            sceneDelegate.window?.rootViewController = nextViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func authFaild() {
        let alert = UIAlertController(title: "Auth failed", message: "Wrong email or password. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yeah", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func authVerification(email: String, password: String) {
        if !state.email.isEmpty && !state.password.isEmpty {
            authComplete()
        } else {
            authFaild()
        }
    }
    
    func authComplete() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let tabController = UITabBarController()
            
            let home = HomeViewController()
            let orders = OrdersViewController()
            let more = UserMenuViewController()
            
            home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Tab Home"), tag: 0)
            orders.tabBarItem = UITabBarItem(title: "Orders", image: UIImage(named: "Tab Bag"), tag: 0)
            more.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "Tab More"), tag: 1)
            
            home.tabBarItem.selectedImage = UIImage(named: "Active Home")
            orders.tabBarItem.selectedImage = UIImage(named: "Active Bag")
            more.tabBarItem.selectedImage = UIImage(named: "Active More")
            
            let controllers = [home, orders, more]
            tabController.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
            
            tabController.tabBar.barTintColor = .white
            tabController.tabBar.clipsToBounds = true
            
            self.navigationController?.isNavigationBarHidden = true

            sceneDelegate.window?.rootViewController = tabController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
}
