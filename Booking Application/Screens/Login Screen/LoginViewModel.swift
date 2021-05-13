//
//  LoginViewModel.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    weak var controller: LoginViewController?
    private var cancellableSet = Set<AnyCancellable>()
    private let serviceAPI = ServiceAPI()
    
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    @Published var inputErrorMessage = ""
    @Published var isLoading: Bool = false
    
    // User Data
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValid: Bool = false
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
        }
    }
    
    init() {
        isFormFieldCompletePublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    private var isEmailEmptyPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                return email == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<EmailCheck, Never> {
        $email
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                switch email.isValidEmail() {
                case true:
                    self.inputErrorMessage = ""
                    return .valid
                case false:
                    if !email.isEmpty {
                        self.inputErrorMessage = "Invalid email address!"
                    }
                    return .invalid
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormFieldCompletePublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isEmailEmptyPublisher, isEmailValidPublisher, isPasswordEmptyPublisher)
            .map { emailIsEmpty, emailIsValid, passwordIsEmpty in
                return !emailIsEmpty && (emailIsValid == .valid) && !passwordIsEmpty
            }
            .eraseToAnyPublisher()
    }
    
    func tryAuth() {
        isLoading = true
        self.serviceAPI.userAccountAuthentication(completion: { result in
            self.isLoading = false
            switch result {
            case .success(let account):
                let preferences = UserDefaults.standard
                preferences.set(account.token, forKey: "access_token")
                
                do {

                    // Encode User
                    
                    let data = try JSONEncoder().encode(account.user)

                    // Write/Set Data
                    
                    UserDefaults.standard.set(data, forKey: "current_user")
                } catch {
                    print("Unable to Encode User (\(error))")
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
                
                self.controller?.authComplete()
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self.errorMessage = "No users with this login and password!"
                    self.showAlert = true
                }
            }
        }, email: self.email, password: self.password)
    }
}

private enum EmailCheck {
    case valid
    case invalid
}
