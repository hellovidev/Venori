//
//  RegistrationViewModel.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import Combine
import SwiftUI
import Foundation

class RegistrationViewModel: ObservableObject {
    weak var controller: RegistrationViewController?
    private var cancellableSet = Set<AnyCancellable>()
    private let serviceAPI = ServiceAPI()
    
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    @Published var inputEmailErrorMessage = ""
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
                    self.inputEmailErrorMessage = ""
                    return .valid
                case false:
                    if !email.isEmpty {
                        self.inputEmailErrorMessage = "Invalid email address!"
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
    
    private var isPasswordRepeatEmptyPublisher: AnyPublisher<Bool, Never> {
        $passwordRepeat
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
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
                return password.count >= 8
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualEmptyPublisher, isPasswordStrengthPublisher)
            .map { passwordIsEmpty, passwordAreEqual, passwordIsStrong in
                if passwordIsEmpty {
                    return .empty
                } else if !passwordAreEqual {
                    self.inputPasswordErrorMessage = "Passwords are not equal!"
                    return .noMatch
                } else if !passwordIsStrong {
                    self.inputPasswordErrorMessage = "Password count should be grater than 8!"
                    return .notStrong
                } else {
                    self.inputPasswordErrorMessage = ""
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
                return nameIsEmpty && surnameIsEmpty
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
        self.serviceAPI.userAccountRegistration(completion: { result in
            switch result {
            case .success:
                self.serviceAPI.userAccountAuthentication(completion: { result in
                    switch result {
                    case .success(let account):

                        let userDefaults = UserDefaults.standard
                        do {
                            try userDefaults.setObject(account.user, forKey: "current_user")
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        //UserDefaults.standard.set(account.user, forKey: "current_user")

                        
                        UserDefaults.standard.set(account.token, forKey: "access_token")
                        UserDefaults.standard.synchronize()
                        self.controller?.registrationComplete()
                    case .failure(let error):
                        print(error)
                    }
                }, email: self.email, password: self.password)
            case .failure(let error):
                print(error)
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

extension UserDefaults { //: ObjectSavable
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
