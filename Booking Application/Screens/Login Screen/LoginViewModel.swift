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
    private let serverRequests = ServerRequest()
    let emailProviders = ["@gmail.com", "@icloud.com", "@yahoo.com", "@hotmail.com", "@yandex.com"]
    
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    @Published var inputErrorMessage = ""
    @Published var isLoading: Bool = false
    
    // User Data
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValid: Bool = false
    @Published var hasEmailDomain: Bool = true
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
            print("Cancel!")
        }
    }
    
    init() {
        isEmailHasEmailDomainPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.hasEmailDomain = $0 }
            //.assign(to: \.hasEmailDomain, on: self)
            .store(in: &cancellableSet)
        
        isFormFieldCompletePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.isValid = $0 }
            //.assign(to: \.isValid, on: [weak self])
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
    
    private var isEmailHasEmailDomainPublisher: AnyPublisher<Bool, Never> {
        $email
            .removeDuplicates()
            .map { email in
                return email.contains("@") != email.isEmpty
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
    
    private var isPasswordStrengthPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 8
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormFieldCompletePublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isEmailEmptyPublisher, isEmailValidPublisher, isPasswordEmptyPublisher, isPasswordStrengthPublisher)
            .map { emailIsEmpty, emailIsValid, passwordIsEmpty, passwordIsStrong in
                return !emailIsEmpty && (emailIsValid == .valid) && !passwordIsEmpty && passwordIsStrong
            }
            .eraseToAnyPublisher()
    }
    
    func tryAuthorize() {
        isLoading = true
        self.serverRequests.userAccountAuthentication(completion: { result in
            switch result {
            case .success(let account):
                self.isLoading = false
                let userDefaults = UserDefaults.standard
                do {
                    try userDefaults.setObject(account.user, forKey: "current_user")
                    UserDefaults.standard.set(account.token, forKey: "access_token")
                    UserDefaults.standard.synchronize()
                    
                    self.controller?.authorizationComplete()
                } catch {
                    print("Unable to Encode User (\(error.localizedDescription))")
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    print(error.localizedDescription)
                    switch error.localizedDescription {
                    case "The data couldn’t be read because it is missing.":
                        self.errorMessage = "Authorization faild. Incorrect user credentials!"
                    default:
                        self.errorMessage = error.localizedDescription
                    }
                    self.showAlert = true
                }
            }
        }, email: self.email, password: self.password)
    }
    
}

enum EmailCheck {
    case valid
    case invalid
}
