//
//  Date.swift
//  Booking Application
//
//  Created by student on 17.05.21.
//

import SwiftUI

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

extension Date {
    func getDateCorrectFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let result = formatter.string(from: date)
        return result
    }
    
    func getSelectedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL dd, yyyy"
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let result = formatter.string(from: date)
        return result
    }
    
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
}
