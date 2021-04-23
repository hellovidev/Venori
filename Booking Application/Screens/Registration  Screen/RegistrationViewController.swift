//
//  RegistrationViewController.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import UIKit
import SwiftUI

class RegistrationViewController: UIHostingController<RegistrationView>  {
    private let state = RegistrationViewModel()
    private let serviceAPI = ServiceAPI()
    
    init() {
        let view = RegistrationView(viewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Redirect User To Login Screen
    
    func redirectToSignIn() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let nextViewController = LoginViewController()
            sceneDelegate.window?.rootViewController = nextViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: -> If Registration Succesful Complete Redirect User Into App
    
    func registrationComplete() {
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
    
    // MARK: -> Pop Up for Faild Print
    
    func failPopUp(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -> Function Check Email is Correct
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: -> User Registration Validate Process
    
    func registerValidation() {
        if state.email.isValidEmail() && state.password.isValidPassword() && state.password == state.passwordRepeat {
            self.serviceAPI.userAccountRegistration(name: state.name, surname: state.surname, email: state.email, password: state.password)
            self.serviceAPI.userAccountAuthentication(email: state.email, password: state.password)
            state.controller?.registrationComplete()
        } else if state.password != state.passwordRepeat {
            state.controller?.failPopUp(title: "Authentification faild!", message: "Check password fields.", buttonTitle: "Okay")
        } else if state.email.isValidEmail() && !state.password.isValidPassword() {
            state.controller?.failPopUp(title: "Authentification faild!", message: "Password has wrong value.", buttonTitle: "Okay")
        } else if !state.email.isValidEmail() && state.password.isValidPassword() {
            state.controller?.failPopUp(title: "Authentification faild!", message: "Email has wrong value.", buttonTitle: "Okay")
        }
        else {
            state.controller?.failPopUp(title: "Authentification faild!", message: "Password or Email has wrong value.", buttonTitle: "Okay")
        }
    }
    
}
