//
//  RegistrationViewModel.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import Combine
import Foundation

class RegistrationViewModel: ObservableObject {
    weak var controller: RegistrationViewController?
    private var cancellableSet = Set<AnyCancellable>()
    private let serverRequests = ServerRequest()
    let emailProviders = ["@gmail.com", "@icloud.com", "@yahoo.com", "@hotmail.com", "@yandex.com"]
    
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    @Published var inputEmailErrorMessage = ""
    @Published var inputPasswordRepeatErrorMessage = ""
    @Published var inputPasswordErrorMessage = ""
    @Published var inputNameErrorMessage = ""
    @Published var isLoading: Bool = false
    
    // User Data
    
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordRepeat: String = ""
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
            .store(in: &cancellableSet)
        
        isFormFieldCompletePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.isValid = $0 }
            .store(in: &cancellableSet)
        
        isPasswordLengthCorrectPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.inputPasswordErrorMessage = $0 }
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
                    self.inputEmailErrorMessage = ""
                    return .valid
                case false:
                    if !email.isEmpty {
                        self.inputEmailErrorMessage = "Invalid email address!"
                    } else {
                        self.inputEmailErrorMessage = ""
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
    
    private var isPasswordRepeatEmptyPublisher: AnyPublisher<Bool, Never> {
        $passwordRepeat
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordLengthCorrectPublisher: AnyPublisher<String, Never> {
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordStrengthPublisher)
            .map { passwordIsEmpty, passwordIsStrong in
                if !passwordIsEmpty == false && passwordIsStrong == false {
                    return ""
                } else if !passwordIsEmpty && passwordIsStrong {
                    return ""
                } else {
                    return "Password should be > 8 and 256 < symbols!"
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualEmptyPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordRepeat)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { password, passwordRepeat in
                return password == passwordRepeat
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrengthPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 8 && password.count <= 256
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest4(isPasswordEmptyPublisher, arePasswordsEqualEmptyPublisher, isPasswordStrengthPublisher, isPasswordRepeatEmptyPublisher)
            .map { passwordIsEmpty, passwordAreEqual, passwordIsStrong, passwordRepeatIsEmpty in
                if passwordIsEmpty {
                    return .empty
                } else if !passwordAreEqual && !passwordRepeatIsEmpty {
                    self.inputPasswordRepeatErrorMessage = "Passwords are not equal!"
                    return .noMatch
                } else if !passwordIsStrong {
                    if passwordRepeatIsEmpty {
                        self.inputPasswordRepeatErrorMessage = ""
                    }
                    return .notStrong
                } else {
                    self.inputPasswordRepeatErrorMessage = ""
                    return .valid
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isNameEmptyPublisher: AnyPublisher<Bool, Never> {
        $name
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { name in
                return name == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isSurnameEmptyPublisher: AnyPublisher<Bool, Never> {
        $surname
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { surname in
                return surname == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isNameStrengthPublisher: AnyPublisher<Bool, Never> {
        $name
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { name in
                if !name.isEmpty {
                    return name.count >= 2
                } else {
                    return true
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isSurnameStrengthPublisher: AnyPublisher<Bool, Never> {
        $surname
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { surname in
                if !surname.isEmpty {
                    return surname.count >= 2
                } else {
                    return true
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isFullNameEmptyPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isNameEmptyPublisher, isSurnameEmptyPublisher)
            .map { nameIsEmpty, surnameIsEmpty in
                return nameIsEmpty || surnameIsEmpty
            }
            .eraseToAnyPublisher()
    }
    
    private var isFullNameCorrectPublisher: AnyPublisher<NameCheck, Never> {
        Publishers.CombineLatest(isNameStrengthPublisher, isSurnameStrengthPublisher)
            .map { nameIsStrong, surnameIsStrong in
                if !nameIsStrong || !surnameIsStrong {
                    self.inputNameErrorMessage = "Name or surname should be grater than 2!"
                    return .small
                } else {
                    self.inputNameErrorMessage = ""
                    return .valid
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isFullNameValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isFullNameEmptyPublisher, isFullNameCorrectPublisher)
            .map { fullNameIsEmpty, fullNameIsCorrect in
                return !fullNameIsEmpty && (fullNameIsCorrect == .valid)
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormFieldCompletePublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isEmailEmptyPublisher, isEmailValidPublisher, isPasswordValidPublisher, isFullNameValidPublisher)
            .map { emailIsEmpty, emailIsValid, passwordIsValid, fullNameIsCorrect in
                return !emailIsEmpty && (emailIsValid == .valid) && (passwordIsValid == .valid) && fullNameIsCorrect
            }
            .eraseToAnyPublisher()
    }
    
    func tryRegister() {
        isLoading = true
        self.serverRequests.userAccountRegistration(completion: { result in
            switch result {
            case .success:
                self.serverRequests.userAccountAuthentication(completion: { result in
                    switch result {
                    case .success(let account):
                        self.isLoading = false
                        let userDefaults = UserDefaults.standard
                        do {
                            try userDefaults.setObject(account.user, forKey: "current_user")
                            UserDefaults.standard.set(account.token, forKey: "access_token")
                            UserDefaults.standard.synchronize()
                            self.controller?.registrationComplete()
                        } catch {
                            print(error.localizedDescription)
                            self.errorMessage = error.localizedDescription
                            self.showAlert = true
                        }
                    case .failure(let error):
                        self.isLoading = false
                        print(error.localizedDescription)
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                    }
                }, email: self.email, password: self.password)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }, name: name, surname: surname, email: email, password: password)
    }
}

enum PasswordCheck {
    case valid
    case empty
    case notStrong
    case noMatch
}

enum NameCheck {
    case valid
    case empty
    case small
}
