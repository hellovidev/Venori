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
    
    // MARK: -> Loading Categories Data
    
    func fetchDataAboutCategories() {
        var done = false
        
        // Link Generating
        
        guard let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.categoriesRoute.rawValue) else { return }
        
        // Set Request Settings
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
                
                // Decodable JSON Data
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Categories.self, from: data)
                
                // Set Data to API Manager Value of Categories
                
                DispatchQueue.main.async {
                    self.categories = response
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
}

enum StatusCode: Int {
    case complete = 200
    case unauthorized = 401
    case invalid = 422
}

























    // MARK: -> Other Code
    


struct ServerResponse: Decodable {
    let error: String
    let ok: String
}



enum ServerErrorResponse: String {
    case postCallError = "Error: Error calling POST"
    case dataNotReceived = "Error: Didn't receive data"
}



    
    
//    func loadCategoriesData() {
//        guard let url = URL(string: Requests.domainLink.rawValue + Requests.categoriesRouter.rawValue) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) {data, response, error in
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode(Categories.self, from: data) {
//                    DispatchQueue.main.async {
//                        self.categories = decodedResponse
//                    }
//                    return
//                }
//            }
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//
//        }.resume()
//    }
    
    
//    private let url = URL(string: Requests.domainLink.rawValue + Requests.categoriesRouter.rawValue)
//
//
//
//    func loadData() -> AnyPublisher<[Category], Error> {
//        return URLSession.shared.dataTaskPublisher(for: self.url!)
//            .map(\.data)
//            .decode(type: Categories.self, decoder:  JSONDecoder())
//            .map(\.data)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//
    
    
    
    
    
    
    
    
    
    
    
    
    
    //            //             let finalData = try! JSONDecoder().decode(ServerResponse.self, from: data)
    //            //             print(finalData)
    //            //             DispatchQueue.main.async{
    //            //             if finalData.error == "Unauthorized"{
    //            //             self.authenticated = false
    //            //             }
    //            //             }
    
    
    
    
    
    
    
    

    
    





















//        var request = URLRequest(url: URL(string:  "http://dev2.cogniteq.com:3110/api/login?")!)
//            request.httpMethod = "POST"
//
//
////            let postString =  String(format: "email=%@&password=%@", arguments: [txt_emailVirify.text!, language!])
////            print(postString)
////
////            emailString = txt_emailVirify.text!
//
//            request.httpBody = postString.data(using: .utf8)
//            request.addValue("delta141forceSEAL8PARA9MARCOSBRAHMOS", forHTTPHeaderField: "Authorization")
//            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data, error == nil
//                    else
//                {
//                    print("error=\(String(describing: error))")
//                    return
//                }
//
//                do
//                {
//
//                    let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
//                    print(dictionary)
//
//                    let status = dictionary.value(forKey: "status") as! String
//                    let sts = Int(status)
//                    DispatchQueue.main.async()
//                        {
//                            if sts == 200
//                            {
//                                print(dictionary)
//
//
//                            }
//                            else
//                            {
//                               self.alertMessageOk(title: self.Alert!, message: dictionary.value(forKey: "message") as! String)
//
//
//                            }
//                    }
//                }
//                catch
//                {
//                    print(error)
//                }
//
//            }
//            task.resume()
//


//    //private let url = URL(string: APIRequests.dataResource.rawValue + APIRequests.prefixKeyAPI.rawValue + APIRequests.keyAPI.rawValue)!
//    //private let loginURL = URL(string: "http://dev2.cogniteq.com:3110/api/login")
//
//    func getTokenAuth() {
//        let defaults = UserDefaults.standard
//        defaults.set("token", forKey: "access_token")
//
//        // Prepare URL
//        let url = URL(string: "http://dev2.cogniteq.com:3110/api/login?email=asdas&password=asdas")
//        guard let requestUrl = url else { fatalError() }
//        // Prepare URL Request Object
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "POST"
//
//        // HTTP Request Parameters which will be sent in HTTP Request Body
//        let postString = "userId=300&title=My urgent task&completed=false";
//        // Set HTTP Request Body
//        request.httpBody = postString.data(using: String.Encoding.utf8);
//        // Perform HTTP Request
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//                // Check for Error
//                if let error = error {
//                    print("Error took place \(error)")
//                    return
//                }
//
//                // Convert HTTP Response Data to a String
//                if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                    print("Response data string:\n \(dataString)")
//                }
//        }
//        task.resume()
//
//    }
//
//
//
//}



