//
//  HTTP.swift
//  Booking Application
//
//  Created by student on 20.04.21.
//

import Combine
import Foundation

class ServiceAPI: ObservableObject {
    
    // MARK: -> Method For Loading Categories Data
    
    func fetchDataAboutCategories(completion: @escaping (Result<Categories, Error>) -> Void) {
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
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Data Validation
            
            guard let data = data else {
                completion(.failure(NSLocalizedString("Loaded data of categories from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    NSLog(NSLocalizedString("Status Code is 200... Request for categories.", comment: "Success"))
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
                
                let response = try JSONDecoder().decode(Categories.self, from: data)
                
                // Set Data to API Manager Value of Categories
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Method For Loading Places Data
    
    func fetchDataAboutPlaces(completion: @escaping (Result<Places, Error>) -> Void) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue) else { return }
        
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
                completion(.failure(NSLocalizedString("Loaded data of places from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    NSLog(NSLocalizedString("Status Code is 200... Request for places.", comment: "Success"))
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
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Places.self, from: data)
                
                // Set Data to API Manager Value of Places
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Method For Loading Favourites Data
    
    func fetchDataAboutFavourites(completion: @escaping (Result<Places, Error>) -> Void) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.favouritesRoute.rawValue) else { return }
        
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
                completion(.failure(NSLocalizedString("Loaded data of favourites places from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    NSLog(NSLocalizedString("Status Code is 200... Request for favourites places.", comment: "Success"))
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
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Places.self, from: data)
                
                // Set Data to API Manager Value of Places
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    
    // MARK: -> Add Favourite To Place
    
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
                    NSLog(NSLocalizedString("Status Code is 200... Request for add favourite place.", comment: "Success"))
                case 201:
                    NSLog(NSLocalizedString("Status Code is 201... Success storing a new favourite.", comment: "Success"))
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
                
                guard let info = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //guard let info = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
                print(info)
                
                // Decodable JSON Data
                
                let response = try JSONDecoder().decode(Place.self, from: data)
                
                // Get Data to API Manager Value of Schedule for Place
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Delete Favourite From Place
    
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
                    NSLog(NSLocalizedString("Status Code is 200... Request for delete favourite place.", comment: "Success"))
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
    
    // MARK: -> Method For Loading Place By ID
    
    func getPlaceByIdentifier(completion: @escaping (Result<Place, Error>) -> Void, placeIdentifier: Int) {
        guard let url = URL(string: getPlaceLink(placeIdentifier: placeIdentifier)) else { return }
        
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
                completion(.failure(NSLocalizedString("Loaded data of place with id \(placeIdentifier) from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    NSLog(NSLocalizedString("Status Code is 200... Request for place with id \(placeIdentifier).", comment: "Success"))
                case 401:
                    completion(.failure(NSLocalizedString("User is not authenticated!", comment: "Error")))
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
                
                // Read Response Data
                
                guard let info = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                print(info)
                
                // Decodable JSON Data
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Place.self, from: data)
                
                // Set Data to API Manager Value of Places
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Method For Loading Booking History
    
    func fetchDataAboutBookingHistory(completion: @escaping (Result<Orders, Error>) -> Void) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.bookingHistoryRoute.rawValue) else { return }
        
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
                completion(.failure(NSLocalizedString("Loaded data of booking history from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    NSLog(NSLocalizedString("Status Code is 200... Request for booking history.", comment: "Success"))
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
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Orders.self, from: data)
                
                // Set Data to API Manager Value of Booking History
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Method For Loading Orders
    
    func fetchDataAboutOrders(completion: @escaping (Result<Orders, Error>) -> Void) {
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.ordersRoute.rawValue) else { return }
        
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
                completion(.failure(NSLocalizedString("Loaded data of orders from server is empty!", comment: "Error")))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    NSLog(NSLocalizedString("Status Code is 200... Request for orders.", comment: "Success"))
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
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Orders.self, from: data)
                
                // Set Data to API Manager Value of Orders
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Method For Cancel Orders
    
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
                    NSLog(NSLocalizedString("Status Code is 200... Order canceled.", comment: "Success"))
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
                print(response)
                
                // Set Data to API Manager Value of Message
                
                DispatchQueue.main.async {
                    completion(.success(response["message"] as! String))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Check Place Free Time For Reservation
    
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
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            
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
                    NSLog(NSLocalizedString("Status Code is 200... Request for available time in place.", comment: "Success"))
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
                
                // Read Response Data
                
                //                do {
                //                                    guard let info = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                //                                    print(info)
                //                } catch {
                //                    print(error)
                //                }
                
                //                guard let info = try JSONSerialization.jsonObject(with: data) as? [String] else { return }
                //                print(info)
                
                // Decodable JSON Data
                
                let response = try JSONDecoder().decode([String].self, from: data)
                
                // Get Data to API Manager Value of Available Time for Place
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Check Place Free Time For Reservation
    
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
                    NSLog(NSLocalizedString("Status Code is 200... Request for week schedule in place.", comment: "Success"))
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
                
                // Get Data to API Manager Value of Schedule for Place
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Logout From User Account
    
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
                    NSLog(NSLocalizedString("Status Code is 200... Request for log out.", comment: "Success"))
                    UserDefaults.standard.removeObject(forKey: "access_token")
                    UserDefaults.standard.removeObject(forKey: "current_user")
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
                
                // Get Data to API Manager Value of Message About Log Out
                
                DispatchQueue.main.async {
                    completion(.success(response["message"] as! String))
                }
            } catch {
                completion(.failure(error))
            }
        })
        .resume()
    }
    
    // MARK: -> Authentication User Account
    
    func userAccountAuthentication(completion: @escaping (Result<Account, Error>) -> Void, email: String, password: String) {
        
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
                    NSLog(NSLocalizedString("Status Code is 200... Request for sign in.", comment: "Success"))
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
    
    // MARK: -> Sent Current User Location
    
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
                    NSLog(NSLocalizedString("Status Code is 200... Request for user location.", comment: "Success"))
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: -> Registration User Account
    
    func userAccountRegistration(name: String, surname: String, email: String, password: String) {
        var done = false
        
        //           case 422:
        //                                    completion(.failure(NSLocalizedString("Unprocessable Entity!", comment: "Error")))
        //                                    print("The given data was invalid.")
        
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
                    //self.orders?.data.append(response)
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
    
    func getScheduleLink(id: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(id)/\(DomainRouter.schedulenRoute.rawValue)"
    }
    
    func getCancelOrderLink(orderIdentifier: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.ordersRoute.rawValue + "/\(orderIdentifier)"
    }
    
    func getPlaceLink(placeIdentifier: Int) -> String {
        return DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(placeIdentifier)"
    }
    
}

// MARK: -> Get Data Results or Error from Completion

enum Result<Success, Error: Swift.Error> {
    case success(Success)
    case failure(Error)
}

// Override The Result.get() Method

extension Result {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

// Use Generics - This is Where You Can Decode Your Data

extension Result where Success == Data {
    func decoded<T: Codable>(using decoder: JSONDecoder = .init()) throws -> T {
        let data = try get()
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: -> Added Functionality For Return Error As String

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

// MARK: -> HTTP Status Codes Precess as Error

enum HTTPStatusCode: Int, Error {
    
    // The response class representation of status codes, these get grouped by their first digit.
    enum ResponseType {
        
        // -> informational: This class of status code indicates a provisional response, consisting only of the Status-Line and optional headers, and is terminated by an empty line.
        case informational
        
        // -> success: This class of status codes indicates the action requested by the client was received, understood, accepted, and processed successfully.
        case success
        
        // -> redirection: This class of status code indicates the client must take additional action to complete the request.
        case redirection
        
        // -> clientError: This class of status code is intended for situations in which the client seems to have erred.
        case clientError
        
        // -> serverError: This class of status code indicates the server failed to fulfill an apparently valid request.
        case serverError
        
        // -> undefined: The class of the status code cannot be resolved.
        case undefined
    }
    
    // Informational - 1xx
    
    // -> continue: The server has received the request headers and the client should proceed to send the request body.
    case `continue` = 100
    
    // -> switchingProtocols: The requester has asked the server to switch protocols and the server has agreed to do so.
    case switchingProtocols = 101
    
    // -> processing: This code indicates that the server has received and is processing the request, but no response is available yet.
    case processing = 102
    
    // Success - 2xx
    
    // -> ok: Standard response for successful HTTP requests.
    case ok = 200
    
    // -> created: The request has been fulfilled, resulting in the creation of a new resource.
    case created = 201
    
    // -> accepted: The request has been accepted for processing, but the processing has not been completed.
    case accepted = 202
    
    // -> nonAuthoritativeInformation: The server is a transforming proxy (e.g. a Web accelerator) that received a 200 OK from its origin, but is returning a modified version of the origin's response.
    case nonAuthoritativeInformation = 203
    
    // -> noContent: The server successfully processed the request and is not returning any content.
    case noContent = 204
    
    // -> resetContent: The server successfully processed the request, but is not returning any content.
    case resetContent = 205
    
    // -> partialContent: The server is delivering only part of the resource (byte serving) due to a range header sent by the client.
    case partialContent = 206
    
    // -> multiStatus: The message body that follows is an XML message and can contain a number of separate response codes, depending on how many sub-requests were made.
    case multiStatus = 207
    
    // -> alreadyReported: The members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again.
    case alreadyReported = 208
    
    // -> IMUsed: The server has fulfilled a request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance.
    case IMUsed = 226
    
    // Redirection - 3xx
    
    // -> multipleChoices: Indicates multiple options for the resource from which the client may choose
    case multipleChoices = 300
    
    // -> movedPermanently: This and all future requests should be directed to the given URI.
    case movedPermanently = 301
    
    // -> found: The resource was found.
    case found = 302
    
    // -> seeOther: The response to the request can be found under another URI using a GET method.
    case seeOther = 303
    
    // -> notModified: Indicates that the resource has not been modified since the version specified by the request headers If-Modified-Since or If-None-Match.
    case notModified = 304
    
    // -> useProxy: The requested resource is available only through a proxy, the address for which is provided in the response.
    case useProxy = 305
    
    // -> switchProxy: No longer used. Originally meant "Subsequent requests should use the specified proxy.
    case switchProxy = 306
    
    // -> temporaryRedirect: The request should be repeated with another URI.
    case temporaryRedirect = 307
    
    // -> permenantRedirect: The request and all future requests should be repeated using another URI.
    case permenantRedirect = 308
    
    // Client Error - 4xx
    
    // -> badRequest: The server cannot or will not process the request due to an apparent client error.
    case badRequest = 400
    
    // -> unauthorized: Similar to 403 Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided.
    case unauthorized = 401
    
    // -> paymentRequired: The content available on the server requires payment.
    case paymentRequired = 402
    
    // -> forbidden: The request was a valid request, but the server is refusing to respond to it.
    case forbidden = 403
    
    // -> notFound: The requested resource could not be found but may be available in the future.
    case notFound = 404
    
    // -> methodNotAllowed: A request method is not supported for the requested resource. e.g. a GET request on a form which requires data to be presented via POST
    case methodNotAllowed = 405
    
    // -> notAcceptable: The requested resource is capable of generating only content not acceptable according to the Accept headers sent in the request.
    case notAcceptable = 406
    
    // -> proxyAuthenticationRequired: The client must first authenticate itself with the proxy.
    case proxyAuthenticationRequired = 407
    
    // -> requestTimeout: The server timed out waiting for the request.
    case requestTimeout = 408
    
    // -> conflict: Indicates that the request could not be processed because of conflict in the request, such as an edit conflict between multiple simultaneous updates.
    case conflict = 409
    
    // -> gone: Indicates that the resource requested is no longer available and will not be available again.
    case gone = 410
    
    // -> lengthRequired: The request did not specify the length of its content, which is required by the requested resource.
    case lengthRequired = 411
    
    // -> preconditionFailed: The server does not meet one of the preconditions that the requester put on the request.
    case preconditionFailed = 412
    
    // -> payloadTooLarge: The request is larger than the server is willing or able to process.
    case payloadTooLarge = 413
    
    // -> URITooLong: The URI provided was too long for the server to process.
    case URITooLong = 414
    
    // -> unsupportedMediaType: The request entity has a media type which the server or resource does not support.
    case unsupportedMediaType = 415
    
    // -> rangeNotSatisfiable: The client has asked for a portion of the file (byte serving), but the server cannot supply that portion.
    case rangeNotSatisfiable = 416
    
    // -> expectationFailed: The server cannot meet the requirements of the Expect request-header field.
    case expectationFailed = 417
    
    // -> teapot: This HTTP status is used as an Easter egg in some websites.
    case teapot = 418
    
    // -> misdirectedRequest: The request was directed at a server that is not able to produce a response.
    case misdirectedRequest = 421
    
    // -> unprocessableEntity: The request was well-formed but was unable to be followed due to semantic errors.
    case unprocessableEntity = 422
    
    // -> locked: The resource that is being accessed is locked.
    case locked = 423
    
    // -> failedDependency: The request failed due to failure of a previous request (e.g., a PROPPATCH).
    case failedDependency = 424
    
    // -> upgradeRequired: The client should switch to a different protocol such as TLS/1.0, given in the Upgrade header field.
    case upgradeRequired = 426
    
    // -> preconditionRequired: The origin server requires the request to be conditional.
    case preconditionRequired = 428
    
    // -> tooManyRequests: The user has sent too many requests in a given amount of time.
    case tooManyRequests = 429
    
    // -> requestHeaderFieldsTooLarge: The server is unwilling to process the request because either an individual header field, or all the header fields collectively, are too large.
    case requestHeaderFieldsTooLarge = 431
    
    // -> noResponse: Used to indicate that the server has returned no information to the client and closed the connection.
    case noResponse = 444
    
    // -> unavailableForLegalReasons: A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource.
    case unavailableForLegalReasons = 451
    
    // -> SSLCertificateError: An expansion of the 400 Bad Request response code, used when the client has provided an invalid client certificate.
    case SSLCertificateError = 495
    
    // -> SSLCertificateRequired: An expansion of the 400 Bad Request response code, used when a client certificate is required but not provided.
    case SSLCertificateRequired = 496
    
    // -> HTTPRequestSentToHTTPSPort: An expansion of the 400 Bad Request response code, used when the client has made a HTTP request to a port listening for HTTPS requests.
    case HTTPRequestSentToHTTPSPort = 497
    
    // -> clientClosedRequest: Used when the client has closed the request before the server could send a response.
    case clientClosedRequest = 499
    
    // Server Error - 5xx
    
    // -> internalServerError: A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.
    case internalServerError = 500
    
    // -> notImplemented: The server either does not recognize the request method, or it lacks the ability to fulfill the request.
    case notImplemented = 501
    
    // -> badGateway: The server was acting as a gateway or proxy and received an invalid response from the upstream server.
    case badGateway = 502
    
    // -> serviceUnavailable: The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state.
    case serviceUnavailable = 503
    
    // -> gatewayTimeout: The server was acting as a gateway or proxy and did not receive a timely response from the upstream server.
    case gatewayTimeout = 504
    
    // -> HTTPVersionNotSupported: The server does not support the HTTP protocol version used in the request.
    case HTTPVersionNotSupported = 505
    
    // -> variantAlsoNegotiates: Transparent content negotiation for the request results in a circular reference.
    case variantAlsoNegotiates = 506
    
    // -> insufficientStorage: The server is unable to store the representation needed to complete the request.
    case insufficientStorage = 507
    
    // -> loopDetected: The server detected an infinite loop while processing the request.
    case loopDetected = 508
    
    // -> notExtended: Further extensions to the request are required for the server to fulfill it.
    case notExtended = 510
    
    // -> networkAuthenticationRequired: The client needs to authenticate to gain network access.
    case networkAuthenticationRequired = 511
    
    // The class (or group) which the status code belongs to.
    var responseType: ResponseType {
        switch self.rawValue {
        case 100..<200:
            return .informational
        case 200..<300:
            return .success
        case 300..<400:
            return .redirection
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .undefined
        }
    }
    
}

// MARK: -> Get Status Code of HTTP Response

extension HTTPURLResponse {
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
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










extension Date {
    func convertServerOrderDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        //dateFormatter.date(from: date)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "LLLL dd, yyyy h:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        if let dateConverted = dateFormatter.date(from: date) {
            return dateFormatterPrint.string(from: dateConverted)
        } else {
            return "There was an error decoding the string"
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
    case schedulenRoute = "schedule"
    case ordersRoute = "orders"
    case bookingHistoryRoute = "booking_history"
    case favouritesRoute = "user/favourites"
    case currentLocationRoute = "user/location"
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







class ContentDataSource: ObservableObject {
    @Published var items = [Order]()
    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true
    
    //Temp
    @Published var place = Place()
    
    init() {
        loadMoreContent()
    }
    
    func loadMoreContentIfNeeded(currentItem item: Order?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.bookingHistoryRoute.rawValue)!
        
        url.queryItems = [
            URLQueryItem(name: "page", value: "\(self.currentPage)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map(\.data)
            .decode(type: Orders.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.canLoadMorePages = (response.lastPage != response.currentPage)
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map({ response in
                print(response.data)
                self.items.append(contentsOf: response.data)
                return self.items
            })
            .catch({ _ in Just(self.items) })
            .assign(to: &$items)
    }
    
    func loadPlaceContent(placeIdentifier: Int) {
        let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(placeIdentifier)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Place.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .map({ response in
                print(response)
                self.place = response
                return self.place
            })
            .catch({ _ in Just(self.place) })
            .assign(to: &$place)
    }
}
