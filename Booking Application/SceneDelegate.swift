//
//  SceneDelegate.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        //let contentView = //HomeView()//LoginView(loginViewModel: LoginViewModel()).environment(\.managedObjectContext, context)

        /*
         let tabController = UITabBarController()
         let popular = PopularViewController()
         let search = SearchViewController()
         
         popular.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "film"), tag: 0)
         search.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
         
         let controllers = [popular, search]
         tabController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
         
         if !state.isAuth {
             currentWindow.rootViewController = LoginViewController()
         } else {
             currentWindow.rootViewController = tabController
         }
         */
        
        
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            if UserDefaults.standard.string(forKey: "access_token") != nil {
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
                
                //navigationController.isNavigationBarHidden = true

                window.rootViewController = tabController
                window.makeKeyAndVisible()
            } else {
                window.rootViewController = LoginViewController()
            }
            
            //window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

