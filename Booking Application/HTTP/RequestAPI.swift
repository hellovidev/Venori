//
//  HTTP.swift
//  Booking Application
//
//  Created by student on 20.04.21.
//

import Foundation
import Combine

class RequestAPI: ObservableObject {
    @Published var access: Token?
    
    func isLoginRequestComplete(email: String, password: String) -> Bool {
        var result: Bool = false
        
        access?.setToken(token: getTokenAuthentication(email: "", password: ""))
        
        let defaults = UserDefaults.standard
        //defaults.set(access.token, forKey: "access_token")
        
        return result
    }
    
    func getTokenAuthentication(email: String, password: String) -> String {
        
        
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
        return ""
    }

    
    
    
}
    
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

    

    
//    func loadData() -> AnyPublisher<[User], Error> {
//        return URLSession.shared.dataTaskPublisher(for: self.url)
//            .map(\.data)
//            .decode(type: Results.self, decoder:  JSONDecoder())
//            .map(\.items)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//
//
//
//        func fetchData() {
//            let task = URLSession.shared.dataTask(with: self.loginURL!) {(data, response, error) in
//                if error == nil {
//                    if let safeData = data {
//                        let results = try? JSONDecoder().decode(Token.self, from: safeData)
//                        DispatchQueue.main.async {
//                            self.items = results!.token
//                        }
//                    }
//                }
//            }
//            task.resume()
//        }
        
    
//    func userAuthentification() {
//
//    }
//
//    func userRegistration() {
//
//    }
//
//    func getTokenAuthentication() -> AnyPublisher<[Token], Error> {
//        return URLSession.shared.dataTaskPublisher(for: self.url)
//            .map(\.data)
//            .decode(type: Token.self, decoder:  JSONDecoder())
//            .map(\.token)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
    
    


//class Dictionary {
//    extension Dictionary {
//        func percentEncoded() -> Data? {
//            return map { key, value in
//                let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
//                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
//                return escapedKey + "=" + escapedValue
//            }
//            .joined(separator: "&")
//            .data(using: .utf8)
//        }
//    }
//}
//
//class CharacterSet {
//    extension CharacterSet {
//        static let urlQueryValueAllowed: CharacterSet = {
//            let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
//            let subDelimitersToEncode = "!$&'()*+,;="
//
//            var allowed = CharacterSet.urlQueryAllowed
//            allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
//            return allowed
//        }()
//    }
//}
//


//// prepare json data
//let json: [String: Any] = ["title": "ABC",
//                           "dict": ["1":"First", "2":"Second"]]
//
//let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//// create post request
//let url = URL(string: "http://httpbin.org/post")!
//var request = URLRequest(url: url)
//request.httpMethod = "POST"
//
//// insert json data to the request
//request.httpBody = jsonData
//
//let task = URLSession.shared.dataTask(with: request) { data, response, error in
//    guard let data = data, error == nil else {
//        print(error?.localizedDescription ?? "No data")
//        return
//    }
//    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//    if let responseJSON = responseJSON as? [String: Any] {
//        print(responseJSON)
//    }
//}
//
//task.resume()

























//
//import Foundation
//import Combine
//
//
//class HttpApi : ObservableObject {
//    // var didChange = PassthroughSubject<HttpApi, Never>()
//    // var authenticated = false
//    // {
//    // didSet{
//    // didChange.send(self)
//    // }
//    // }
//    
//    func getMethod(email:String,password:String) {
//        guard let url = URL(string: "http://dev2.cogniteq.com:3110/api/login") else {
//            print("Error: cannot create URL")
//            return
//        }
//        
//        let body:[String:String]=["email":email,"password":password]
//        
//        let finalBody = try! JSONSerialization.data(withJSONObject: body)
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = finalBody
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print("Error: error calling POST")
//                print(error!)
//                return
//            }
//            guard let data = data else {
//                print("Error: Did not receive data")
//                return
//            }
//            
//            if let response = response as? HTTPURLResponse {
//                print("Response HTTP Status code: \(response.statusCode)")
//                
//            } else {
//                return
//                
//            }
//            print(data)
//            // let finalData = try! JSONDecoder().decode(MsgServer.self, from: data)
//            // print(finalData)
//            // DispatchQueue.main.async{
//            // if finalData.error == "Unauthorized"{
//            // self.authenticated = false
//            // }
//            // }
//            
//            do {
//                
//                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                    
//                    print("Error: Cannot convert data to JSON object")
//                    
//                    return
//                }
//                print(jsonObject)
//                DispatchQueue.main.async {
//                    
//                    if let accessToken = jsonObject["access_token"] as? String{
//                        let preferences = UserDefaults.standard
//                        preferences.set(accessToken, forKey: "accessToken")
//                        print(accessToken)
//                    }
//                }
//            } catch {
//                print("Error: Trying to convert JSON data to string")
//                return
//            }
//            
//            
//        }.resume()
//    }
//}
//
//struct MsgServer: Decodable {
//    let error :String
//    let ok:String
//}
