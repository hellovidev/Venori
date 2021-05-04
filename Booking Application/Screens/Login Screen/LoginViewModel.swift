//
//  LoginViewModel.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var email: String = ""
    @Published var password: String = ""
    weak var controller: LoginViewController?
}
