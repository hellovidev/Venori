//
//  HomeViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import SwiftUI
import Combine

class HomeViewController: UIHostingController<HomeView>  {
    private let state = HomeViewModel()
    private var cancellable: AnyCancellable?
    var api = RequestAPI()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        cancellable?.cancel()
    }
    
    init() {
        let view = HomeView(homeViewModel: state)
        super.init(rootView: view)
        cancellable = api.loadData().sink(receiveCompletion: {_ in}, receiveValue: { items in self.state.categories = items })
        state.controller = self
        //self.api.loadPlacesData()
        //self.api.loadCategoriesData()
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func seeAllRestaraunts() {
//        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//            let nextViewController = AllRestaurantsViewController()
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//            sceneDelegate.window?.rootViewController = nextViewController
//            sceneDelegate.window?.makeKeyAndVisible()
//        }
        
        let navigationController = UINavigationController(rootViewController: AllRestaurantsViewController())
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated:true, completion: nil)
    }
    
    func seeAllCategories() {
        let navigationController = UINavigationController(rootViewController: AllCategoriesViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
        
//        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//            let nextViewController = AllCategoriesViewController()
//
//
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//            sceneDelegate.window?.rootViewController = nextViewController
//            sceneDelegate.window?.makeKeyAndVisible()
//        }
    }
    
    
    
    func redirectToRestarauntDetails() {
        let navigationController = UINavigationController(rootViewController: DetailsRestarauntViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }

}
