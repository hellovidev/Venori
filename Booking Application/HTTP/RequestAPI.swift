//
//  HTTP.swift
//  Booking Application
//
//  Created by student on 20.04.21.
//

import Foundation
import Combine

class RequestAPI: ObservableObject {
    @Published var account: Account?
    @Published var places: Restaraunts?
    @Published var categories: Categories?
    
    func userAccountRegistration(name: String, surname: String, email: String, password: String) {
        var done = false

        guard let url = URL(string: Requests.domainLink.rawValue + Requests.registerRouter.rawValue) else {
            print("Error: Can't create URL")
            return
        }
        
        let data: [String: String] = ["first_name": name, "second_name": surname, "email": email, "password": password]
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue( "Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print(ServerErrorResponse.postCallError.rawValue + "Error value: \(error!)")
                return
            }
            
            guard let data = data else {
                print(ServerErrorResponse.dataNotReceived.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
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
                // Read response data
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                print(jsonObject)
            } catch {
                print(error)
            }
        })
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    func userAccountAuthentication(email: String, password: String) {
        var done = false
        
        guard let url = URL(string: Requests.domainLink.rawValue + Requests.loginRouter.rawValue) else {
            print("Error: Can't create URL")
            return
        }
        
        let data: [String: String] = ["email": email, "password": password]
        let body = try! JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print(ServerErrorResponse.postCallError.rawValue + "Error value: \(error!)")
                return
            }
            
            guard let data = data else {
                print(ServerErrorResponse.dataNotReceived.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
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
                // Read response data
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                print(jsonObject)
                
                // Decodable
                let decoder = JSONDecoder()
                let response = try decoder.decode(Account.self, from: data)
                DispatchQueue.main.async {
                    self.account = response
                    let preferences = UserDefaults.standard
                    preferences.set(self.account?.token, forKey: "access_token")
                }
                print(response)
            } catch {
                print(error)
            }
        })
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }

    func userAccountLogout() {
        var done = false

        guard let url = URL(string: Requests.domainLink.rawValue + Requests.logoutRouter.rawValue) else {
            print("Error: Can't create URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        print(UserDefaults.standard.string(forKey: "access_token")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print(ServerErrorResponse.postCallError.rawValue + "Error value: \(error!)")
                return
            }
            
            guard let data = data else {
                print(ServerErrorResponse.dataNotReceived.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
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
                // Read response data
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                print(jsonObject)
            } catch {
                print(error)
            }
        })
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    func loadPlacesData() {
        guard let url = URL(string: Requests.domainLink.rawValue + Requests.placesRouter.rawValue) else {
            print("Error: Can't create URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        print(UserDefaults.standard.string(forKey: "access_token")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print(ServerErrorResponse.postCallError.rawValue + "Error value: \(error!)")
                return
            }
            
            guard let data = data else {
                print(ServerErrorResponse.dataNotReceived.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
                switch response.statusCode {
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                default:
                    print("Complete")
                }
            } else {
                return
            }
            
            do {
                // Read response data
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                //print(jsonObject)
                
                // Decodable
                let decoder = JSONDecoder()
                let response = try decoder.decode(Restaraunts.self, from: data)
                DispatchQueue.main.async {
                    self.places = response
                }
                print(response.data[0])
            } catch {
                print(error)
            }
        })
        task.resume()
    }
    
    func loadCategoriesData() {
        guard let url = URL(string: Requests.domainLink.rawValue + Requests.categoriesRouter.rawValue) else {
            print("Error: Can't create URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        print(UserDefaults.standard.string(forKey: "access_token")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print(ServerErrorResponse.postCallError.rawValue + "Error value: \(error!)")
                return
            }
            
            guard let data = data else {
                print(ServerErrorResponse.dataNotReceived.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
                switch response.statusCode {
                case 401:
                    print("Unauthorized")
                case 422:
                    print("The given data was invalid.")
                default:
                    print("Complete")
                }
            } else {
                return
            }
            
            do {
                // Read response data
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                print(jsonObject)
                
                // Decodable
                let decoder = JSONDecoder()
                let response = try decoder.decode(Categories.self, from: data)
                DispatchQueue.main.async {
                    self.categories = response
                }
            } catch {
                print(error)
            }
        })
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //            //             let finalData = try! JSONDecoder().decode(ServerResponse.self, from: data)
    //            //             print(finalData)
    //            //             DispatchQueue.main.async{
    //            //             if finalData.error == "Unauthorized"{
    //            //             self.authenticated = false
    //            //             }
    //            //             }
    
    
    
    
    
    
    
    
    struct ServerResponse: Decodable {
        let error: String
        let ok: String
    }
    
    enum Requests: String {
        case domainLink = "http://dev2.cogniteq.com:3110/api/"
        case loginRouter = "login"
        case registerRouter = "register"
        case logoutRouter = "logout"
        case placesRouter = "places"
        case categoriesRouter = "categories"
    }
    
    enum ServerErrorResponse: String {
        case postCallError = "Error: Error calling POST"
        case dataNotReceived = "Error: Didn't receive data"
    }
    
    
    
}

enum StatusCodes: Int {
    case complete = 200
    case unauthorized = 401
    case invalid = 422
}

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



