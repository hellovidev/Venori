//
//  HTTP.swift
//  Booking Application
//
//  Created by student on 20.04.21.
//

import Foundation
import SwiftUI

// MARK: -> Domain Routes

public enum DomainRouter: String {
    case generalDomain = "http://dev2.cogniteq.com:3110/"
    case linkAPIRequests = "http://dev2.cogniteq.com:3110/api/"
    case loginRoute = "login"
    case registerRoute = "register"
    case logoutRoute = "logout"
    case placesRoute = "places"
    case categoriesRoute = "categories"
    case reserveRoute = "reserve"
    case reservationRoute = "reservation"
    case schedulenRoute = "schedule"
    case ordersRoute = "orders"
    case favouritesRoute = "user/favourites"
    case currentLocationRoute = "user/location"
    case reviewsRoute = "reviews"
}

class ServerRequest: ObservableObject {
    
    // MARK: -> User Registration & Login & Logout
    
    func userAccountRegistration(completion: @escaping (Result<[String: Any], Error>) -> Void, name: String, surname: String, email: String, password: String) {
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
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data from server about sign in is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 201:
                    print("Register: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 201... Request for sign in.", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                case 422:
                    completion(.failure(NSLocalizedString("The given data was invalid.", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Read Response Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //print(response)
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    func userAccountAuthentication(completion: @escaping (Result<Account, Error>) -> Void, email: String, password: String) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.loginRoute.rawValue) else { return }
        
        // Request Body Generating
        
        let data: [String: String] = ["email": email, "password": password]
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data from server about sign in is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Login: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Request for sign in.", comment: "Success"))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Read Response Data
                
                //guard let info = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //print(info)
                
                // Decodable JSON Data
                
                let response = try JSONDecoder().decode(Account.self, from: data)
                
                // Get Data to API Manager Value of Message About User
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    func userAccountLogout(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.logoutRoute.rawValue) else { return }
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data from server about log out is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Logout: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Request for log out.", comment: "Success"))
                    UserDefaults.standard.removeObject(forKey: "access_token")
                    UserDefaults.standard.removeObject(forKey: "current_user")
                    UserDefaults.standard.removeObject(forKey: "latitude")
                    UserDefaults.standard.removeObject(forKey: "longitude")
                    UserDefaults.standard.synchronize()
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Decodable JSON Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                
                DispatchQueue.main.async {
                    completion(.success(response["message"] as! String))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    func sentCurrentUserLocation(completion: @escaping (Result<[String: Any], Error>) -> Void, latitude: Double, longitude: Double, address: String) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.currentLocationRoute.rawValue) else { return }
        
        // Request Body Generating
        
        let data: [String: Any] = ["address_full": address, "address_lat": latitude, "address_lon": longitude]
        let body = try! JSONSerialization.data(withJSONObject: data)
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data of user location from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("User location sent: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Request for user location.", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                case 422:
                    completion(.failure(NSLocalizedString("The given data was invalid.", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Decodable JSON Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //print(response)
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Actions With Place Object
    
    func addToFavourite(completion: @escaping (Result<Place, Error>) -> Void, placeIdentifier: Int) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.favouritesRoute.rawValue) else { return }
        
        // Request Body Generating
        
        let data: [String: Any] = ["place": placeIdentifier]
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data of response for add favourite from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Add favourite: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Request for add favourite place.", comment: "Success"))
                case 201:
                    print("Add favourite: 201 OK")
                    //NSLog(NSLocalizedString("Status Code is 201... Success storing a new favourite.", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Read Response Data
                
                //guard let info = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //print(info)
                
                // Decodable JSON Data
                
                let response = try JSONDecoder().decode(Place.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    func deleteFavourite(completion: @escaping (Result<String, Error>) -> Void, placeIdentifier: Int) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.favouritesRoute.rawValue) else { return }
        
        // Request Body Generating
        
        let data: [String: Any] = ["place": placeIdentifier]
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data of response for delete favourite from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Delete favourite: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Request for delete favourite place.", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Decodable JSON Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                
                DispatchQueue.main.async {
                    completion(.success(response["message"] as! String))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    func getScheduleOfPlace(completion: @escaping (Result<[Schedule], Error>) -> Void, placeIdentifier: Int) {
        guard let url = URL(string: getScheduleLink(id: placeIdentifier)) else { return }
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data of week schedule for place with id: \(placeIdentifier) from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Get schedule: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Request for week schedule in place.", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Read Response Data
                
                //guard let info = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
                //print(info)
                
                // Decodable JSON Data
                
                let response = try JSONDecoder().decode([Schedule].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    func reserveTablePlace(placeIdentifier: Int, adultsAmount: Int, duration: Float, date: String, time: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
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
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data of week schedule for place with id: \(placeIdentifier) from server is empty!", comment: "Error")))
                return
            }
            
            // Get Response from API
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Reserve: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... POST reserve data.", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Read Response Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //print(response)
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        task.resume()
    }
    
    func getPlaceAvailableTime(completion: @escaping (Result<[String], Error>) -> Void, placeIdentifier: Int, adultsAmount: Int, duration: Float, date: String) {
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
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data of available time from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Get available time: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Request for available time in place.", comment: "Success"))
                case 400:
                    completion(.failure(NSLocalizedString("Place not found!", comment: "Error")))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                case 422:
                    completion(.failure(NSLocalizedString("Validation error! The given data was invalid. The date must be a date after yesterday.", comment: "Error")))
                case 429:
                    completion(.failure(NSLocalizedString("Too many requests!", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                let info = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if info != nil {
                    //print(info!["message"] as Any)
                    completion(.success([String]()))
                } else {
                    
                    // Decodable JSON Data
                    
                    guard let response = try JSONDecoder().decode([String]?.self, from: data) else {
                        return completion(.success([String]()))
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                }
            } catch {
                //print(error.localizedDescription)
                completion(.failure(error))
            }
        })
        .resume()
    }

    // MARK: -> Methods For Actions With Order Object
    
    func cancelOrderInProgress(completion: @escaping (Result<String, Error>) -> Void, orderIdentifier: Int) {
        guard let url = URL(string: getCancelOrderLink(orderIdentifier: orderIdentifier)) else { return }
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Cancel order data from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Cancel order: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Order canceled.", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Decodable JSON Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //print(response)
                
                DispatchQueue.main.async {
                    completion(.success(response["message"] as! String))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Methods For Actions With Review Object
    
    func deleteReview(completion: @escaping (Result<String, Error>) -> Void, reviewIdentifier: Int) {
        guard let url = URL(string: getReviewLink(reviewIdentifier: reviewIdentifier)) else { return }
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Bearer Token for Authorized User
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
            // Check Presence of Errors
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Delete review from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Delete review: 200 OK")
                    //NSLog(NSLocalizedString("Status Code is 200... Review deleted.", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
                default:
                    completion(.failure(NSLocalizedString("Unknown status code error!", comment: "Error")))
                }
            } else {
                completion(.failure(NSLocalizedString("HTTP response is empty!", comment: "Error")))
                return
            }
            
            do {
                
                // Decodable JSON Data
                
                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //print(response)
                
                DispatchQueue.main.async {
                    completion(.success(response["message"] as! String))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Additional Functions To Generate Links
    
    func getReserveLink(id: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(id)/\(DomainRouter.reserveRoute.rawValue)"
    }
    
    func getReservationLink(id: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(id)/\(DomainRouter.reservationRoute.rawValue)"
    }
    
    func getScheduleLink(id: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(id)/\(DomainRouter.schedulenRoute.rawValue)"
    }
    
    func getCancelOrderLink(orderIdentifier: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.ordersRoute.rawValue + "/\(orderIdentifier)"
    }
    
    func getPlaceLink(placeIdentifier: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(placeIdentifier)"
    }
    
    func getReviewLink(reviewIdentifier: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.reviewsRoute.rawValue + "/\(reviewIdentifier)"
    }
    
}
