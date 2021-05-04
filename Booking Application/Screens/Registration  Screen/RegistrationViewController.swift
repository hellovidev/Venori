//
//  RegistrationViewController.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import UIKit
import SwiftUI

class RegistrationViewController: UIHostingController<RegistrationView>  {
    private let viewModel = RegistrationViewModel()
    private let serviceAPI = ServiceAPI()
    
    init() {
        let view = RegistrationView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
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
        if viewModel.email.isValidEmail() && viewModel.password.isValidPassword() && viewModel.password == viewModel.passwordRepeat {
            self.serviceAPI.userAccountRegistration(name: viewModel.name, surname: viewModel.surname, email: viewModel.email, password: viewModel.password)
            self.serviceAPI.userAccountAuthentication(completion: { result in
                switch result {
                case .success(let account):
                    let preferences = UserDefaults.standard
                    preferences.set(account.user, forKey: "current_user")
                    preferences.set(account.token, forKey: "access_token")
                case .failure(let error):
                    print(error)
                }
            }, email: viewModel.email, password: viewModel.password)
            viewModel.controller?.registrationComplete()
        } else if viewModel.password != viewModel.passwordRepeat {
            viewModel.controller?.failPopUp(title: "Authentification faild!", message: "Check password fields.", buttonTitle: "Okay")
        } else if viewModel.email.isValidEmail() && !viewModel.password.isValidPassword() {
            viewModel.controller?.failPopUp(title: "Authentification faild!", message: "Password has wrong value.", buttonTitle: "Okay")
        } else if !viewModel.email.isValidEmail() && viewModel.password.isValidPassword() {
            viewModel.controller?.failPopUp(title: "Authentification faild!", message: "Email has wrong value.", buttonTitle: "Okay")
        }
        else {
            viewModel.controller?.failPopUp(title: "Authentification faild!", message: "Password or Email has wrong value.", buttonTitle: "Okay")
        }
    }
    
}
