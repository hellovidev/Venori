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
    private let serviceAPI = ServiceAPI()
    
    init() {
        let view = LoginView(viewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Redirect User To Register Screen
    
    func redirectToSignUp() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let nextViewController = RegistrationViewController()
            sceneDelegate.window?.rootViewController = nextViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: -> Pop Up for Faild Print
    
    func failPopUp(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -> User Registration Validate Process
    
    func authComplete() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let tabController = UITabBarController()
            
            let home = HomeViewController()
            let orders = OrdersViewController()
            let more = MoreViewController()
            
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
    
    // MARK: -> User Login Validate Process
    
    func loginValidation() {
        if state.email.isValidEmail() && state.password.isValidPassword() {
            self.serviceAPI.userAccountAuthentication(completion: { result in
                switch result {
                case .success(let account):
                    let preferences = UserDefaults.standard
                    //preferences.set(account.user, forKey: "current_user")
                    preferences.set(account.token, forKey: "access_token")
                    
                    do {
                        // Create JSON Encoder
                        
                        let encoder = JSONEncoder()

                        // Encode User
                        
                        let data = try encoder.encode(account.user)

                        // Write/Set Data
                        
                        UserDefaults.standard.set(data, forKey: "current_user")

                    } catch {
                        print("Unable to Encode User (\(error))")
                    }
                    
                    self.state.controller?.authComplete()
                case .failure(let error):
                    print(error)
                    self.state.controller?.failPopUp(title: "Authentification faild!", message: "Access Token Empty", buttonTitle: "Okay")
                }
            }, email: self.state.email, password: self.state.password)
        } else if !state.email.isValidEmail() && state.password.isValidPassword() {
            state.controller?.failPopUp(title: "Authentification faild!", message: "Email has wrong value.", buttonTitle: "Okay")
        } else if state.email.isValidEmail() && !state.password.isValidPassword() {
            state.controller?.failPopUp(title: "Authentification faild!", message: "Password has wrong value.", buttonTitle: "Okay")
        } else {
            state.controller?.failPopUp(title: "Authentification faild!", message: "Password or Email has wrong value.", buttonTitle: "Okay")
        }
    }
    
}
