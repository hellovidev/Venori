//
//  UserMenuViewController.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//


    import UIKit
    import SwiftUI

    class UserMenuViewController: UIHostingController<UserMenuView>  {
        private let state = UserMenuViewModel()
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        init() {
            let view = UserMenuView(userMenuViewModel: state)
            super.init(rootView: view)
            state.controller = self
        }
        
        @objc required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }

    


