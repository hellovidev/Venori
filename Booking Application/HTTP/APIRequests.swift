//
//  APIRequests.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

public enum APIRequests: String {
    case prefixKeyAPI = "?api_key="
    case keyAPI = "5c71b9abc803f2afe53656c240048718"
    case posterResource = "https://image.tmdb.org/t/p/w500"
    case dataResource = "https://api.themoviedb.org/3/list/1"
    
    case passForgotLink = "http://dev2.cogniteq.com:3110/api/forgot"
    
    case regLink = "http://dev2.cogniteq.com:3110/api/register/"
    
//    func registrationRequestLinkGenerator(firstName: String, secondName: String, email: String, password: String) -> String {
//        let link = self.regLink + "?first_name=" + firstName + "&second_name=" + secondName + "&email=" + email + "&password=" + password
//        return link
//    }
}


//http://dev2.cogniteq.com:3110/api/reset
//http://dev2.cogniteq.com:3110/api/logout
//http://dev2.cogniteq.com:3110/api/login?email=asdas&password=asdas



//http://dev2.cogniteq.com:3110/api/reviews    +  /1




//schedules
//http://dev2.cogniteq.com:3110/api/schedules/1


//http://dev2.cogniteq.com:3110/api/favourites
