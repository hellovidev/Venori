//
//  LoginViewModel.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    var controller: LoginViewController?
    private var cancellableSet: Set<AnyCancellable> = []
}
