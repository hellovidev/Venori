//
//  HTTP.swift
//  Booking Application
//
//  Created by student on 20.04.21.
//

import Combine
import Foundation

class ServiceAPI: ObservableObject {
    @Published var account: Account?
    @Published var places: Places?
    @Published var categories: Categories?
    @Published var orders: Orders?
    
    @Published var availableTimes: [String]?
    
    // MARK: -> New Method For Loading Categories Data
    
    func fetchDataAboutCategories(completion: @escaping (Categories) -> ()) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.categoriesRoute.rawValue) else { return }
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else { return }
            
            // Data Validation
            
            guard let data = data else { return }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Complete")
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                default:
                    print("Unknown")
                }
            } else {
                return
            }
            
            do {
                
                // Decodable JSON Data
                
                let response = try JSONDecoder().decode(Categories.self, from: data)
                
                // Set Data to API Manager Value of Categories
                
                DispatchQueue.main.async {
                    self.categories = response
                    completion(response)
                }
            } catch {
                print(error)
            }
        })
        .resume()
    }
    
    // MARK: -> Old Method For Loading Categories Data
    
//    func fetchDataAboutCategories() {
//        var done = false
//
//        // Link Generating
//
//        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.categoriesRoute.rawValue) else { return }
//
//        // Set Request Settings
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        // Bearer Token for Authorized User
//
//        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
//
//        // Request to API
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//            // Check Presence of Errors
//
//            guard error == nil else { return }
//
//            // Data Validation
//
//            guard let data = data else { return }
//
//            // Get Response from API
//
//            if let response = response as? HTTPURLResponse {
//                switch response.statusCode {
//                case 401:
//                    print("Unauthorized")
//                case 422:
//                    print("The given data was invalid.")
//                default:
//                    done = true
//                    print("Complete")
//                }
//            } else {
//                return
//            }
//
//            do {
//
//                // Decodable JSON Data
//
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(Categories.self, from: data)
//
//                // Set Data to API Manager Value of Categories
//
//                DispatchQueue.main.async {
//                    self.categories = response
//                }
//            } catch {
//                print(error)
//            }
//        })
//
//        task.resume()
//
//        // Loop for Waiting Results of Status Code
//
//        repeat {
//            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
//        } while !done
//    }
    
    // MARK: -> Registration User Account
    
    func userAccountRegistration(name: String, surname: String, email: String, password: String) {
        var done = false
        
        // Link Generating
        
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.registerRoute.rawValue) else { return }
        
        // Request Body Generating
        
        let data: [String: String] = ["first_name": name, "second_name": surname, "email": email, "password": password]
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Request to API
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // Check Presence of Errors
            
            guard error == nil else { return }
            
            // Data Validation
            
            guard let data = data else { return }
            
            // Get Response from API
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                default:
                    done = true
                    print("Complete")
                }
            } else {
                return
            }
            
            do {
                
                // Read Response Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                print(response)
            } catch {
                print(error)
            }
        })
        task.resume()
        
        // Loop for Waiting Results of Status Code
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    // MARK: -> Authentication User Account
    
    func userAccountAuthentication(email: String, password: String) {
        var done = false
        
        // Link Generating
        
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.loginRoute.rawValue) else { return }
        
        // Request Body Generating
        
        let data: [String: String] = ["email": email, "password": password]
        let body = try! JSONSerialization.data(withJSONObject: data)
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Request to API
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // Check Presence of Errors
            guard error == nil else { return }
            
            // Data Validation
            
            guard let data = data else { return }
            
            // Get Response from API
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                default:
                    done = true
                    print("Complete")
                }
            } else {
                return
            }
            
            do {
                
                guard let response1 = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                print(response1)
                
                // Decodable JSON Data
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Account.self, from: data)
                
                // Saving User Access Token
                
                DispatchQueue.main.async {
                    self.account = response
                    let preferences = UserDefaults.standard
                    preferences.set(self.account?.token, forKey: "access_token")
                }
            } catch {
                print(error)
            }
        })
        task.resume()
        
        // Loop for Waiting Results of Status Code
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    // MARK: -> Logout From User Account
    
    func userAccountLogout() {
        var done = false
        
        // Link Generating
        
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.logoutRoute.rawValue) else { return }
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        // Request to API
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // Check Presence of Errors
            
            guard error == nil else { return }
            
            // Data Validation
            
            guard let data = data else { return }
            
            // Get Response from API
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                default:
                    done = true
                    print("Complete")
                }
            } else {
                return
            }
            
            do {
                
                // Read Response Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                print(response)
            } catch {
                print(error)
            }
        })
        task.resume()
        
        // Loop for Waiting Results of Status Code
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    // MARK: -> Loading Places Data
    
    func fetchDataAboutPlaces() {
        var done = false
        
        // Link Generating
        
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue) else { return }
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // Check Presence of Errors
            
            guard error == nil else { return }
            
            // Data Validation
            
            guard let data = data else { return }
            
            // Get Response from API
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                default:
                    done = true
                    print("Complete")
                }
            } else {
                return
            }
            
            do {
                
                // Read Response Data
                
                guard let info = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                print(info)
                
                // Decodable JSON Data
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Places.self, from: data)
                
                // Set Data to API Manager Value of Places
                
                DispatchQueue.main.async {
                    self.places = response
                }
            } catch {
                print(error)
            }
        })
        task.resume()
        
        // Loop for Waiting Results of Status Code
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    // MARK: -> Reserve Table in Place
    
    func reserveTablePlace(placeIdentifier: Int, adultsAmount: Int, duration: Float, date: String, time: String) {
        var done = false
        
        // Link Generating
        
        guard let url = URL(string: getReserveLink(id: placeIdentifier)) else { return }
        
        // Request Body Generating
        
        let data: [String: Any] = ["date": date, "people": adultsAmount, "staying": duration, "time": time]
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // Check Presence of Errors
            
            guard error == nil else { return }
            
            // Data Validation
            
            guard let data = data else { return }
            
            // Get Response from API
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                case 400:
                    print("Place not found")
                default:
                    done = true
                    print("Complete")
                }
            } else {
                return
            }
            
            do {
                
                // Read Response Data
                
                guard let info = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                print(info)
                
                // Decodable JSON Data
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Order.self, from: data)
                
                // Set Data to API Manager Value of Places
                
                DispatchQueue.main.async {
                    self.orders?.data.append(response)
                }
            } catch {
                print(error)
            }
        })
        task.resume()
        
        // Loop for Waiting Results of Status Code
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    // MARK: -> Check Place Free Time For Reservation
    
    func getPlaceAvailableTime(placeIdentifier: Int, adultsAmount: Int, duration: Float, date: String) {
        var done = false
        
        // Link Generating
        
        guard let url = URL(string: getReservationLink(id: placeIdentifier)) else { return }
        
        // Request Body Generating
        
        let data: [String: Any] = ["date": date, "people": adultsAmount, "staying": duration]
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // Check Presence of Errors
            
            guard error == nil else { return }
            
            // Data Validation
            
            guard let data = data else { return }
            
            // Get Response from API
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                default:
                    done = true
                    print("Complete")
                }
            } else {
                return
            }
            
            do {
                
                // Decodable JSON Data
                
                let decoder = JSONDecoder()
                let response = try decoder.decode([[String]].self, from: data)
                
                // Set Data to API Manager Value of Places
                
                DispatchQueue.main.async {
                    self.availableTimes = response[0]
                    print(response[0])
                }
            } catch {
                print(error)
            }
        })
        task.resume()
        
        // Loop for Waiting Results of Status Code
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    // MARK: -> Additional Functions
    
    func getReserveLink(id: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(id)/\(DomainRouter.reserveRoute.rawValue)"
    }
    
    func getReservationLink(id: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(id)/\(DomainRouter.reservationRoute.rawValue)"
    }
}

// MARK: -> String Extension for Validate Password & Email

extension String {
    func isValidEmail() -> Bool {
        // Here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        if self.count < 8 {
            return false
        } else {
            return true
        }
    }
}

// MARK: -> Enums

enum DomainRouter: String {
    case generalDomain = "http://dev2.cogniteq.com:3110/"
    case linkAPIRequests = "http://dev2.cogniteq.com:3110/api/"
    case loginRoute = "login"
    case registerRoute = "register"
    case logoutRoute = "logout"
    case placesRoute = "places"
    case categoriesRoute = "categories"
    case reserveRoute = "reserve"
    case reservationRoute = "reservation"
}

enum StatusCode: Int {
    case complete = 200
    case unauthorized = 401
    case invalid = 422
    case notfound = 400
}

enum ErrorResponse: String {
    case postCallError = "Error: Error calling POST"
    case dataNotReceived = "Error: Didn't receive data"
}

// MARK: -> Future Combine Functions

//class NetworkManager: ObservableObject {
//    @Published var items = [User]()
//    private let url = URL(string: APIRequests.dataResource.rawValue + APIRequests.prefixKeyAPI.rawValue + APIRequests.keyAPI.rawValue)!
//
//    func loadData() -> AnyPublisher<[User], Error> {
//        return URLSession.shared.dataTaskPublisher(for: self.url)
//            .map(\.data)
//            .decode(type: Results.self, decoder:  JSONDecoder())
//            .map(\.items)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//}
