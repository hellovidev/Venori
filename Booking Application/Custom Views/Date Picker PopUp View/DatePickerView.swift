//
//  DatePickerView.swift
//  Booking Application
//
//  Created by student on 3.05.21.
//

import SwiftUI

struct DatePickerView: View {
    private let serviceAPI = ServiceAPI()
    @Binding var orderDateReservation: Date
    @Binding var show: Bool
    @Binding var times: [Time]
    var placeIdentifier: Int
    var adultsAmount: Int
    var duration: Float
    
    var body: some View {
        ZStack {
            if show {
                
                // Background Color of PopUp View
                
                Color.black.opacity(show ? 0.5 : 0).edgesIgnoringSafeArea(.all)
                
                // PopUp Window
                
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Select the date of the table reservation")
                            .padding([.top, .bottom], 16)
                            .font(Font.system(size: 22, weight: .semibold))
                            .multilineTextAlignment(.center)
                        DatePicker(selection: $orderDateReservation, in: Date()..., displayedComponents: .date, label: {})
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    Button(action: {
                        // Dismiss the PopUp
                        self.serviceAPI.getPlaceAvailableTime(completion: {
                            
                            result in
                            switch result {
                            case .success(let times):
                                //print(times)
                                //self.times = times
                                self.times = [Time]()
                                for item in times {
                                    self.times.append(Time(time: item))
                                }
                            case .failure(let error):
                                print(error)
                            //                                                DispatchQueue.main.async {
                            //                                                    self.viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
                            //                                                  }
                            }
                        }
                        
                        , placeIdentifier: placeIdentifier, adultsAmount: adultsAmount, duration: duration, date: Date().getDateCorrectFormat(date: orderDateReservation))
                        
                        withAnimation(.linear(duration: 0.3)) {
                            show = false
                        }
                    }, label: {
                        Text("Okay")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.top, 13)
                            .padding(.bottom, 13)
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            .frame(maxWidth: .infinity)
                            .shadow(radius: 10)
                    })
                    .frame(maxWidth: 300)
                    .background(Color("Button Color"))
                    .cornerRadius(24)
                    
                }
            }
        }
    }
}

//struct DatePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatePickerView()
//    }
//}


////let date = Date()
//let formatter = DateFormatter()
////Give the format you want to the formatter:
//
//formatter.dateFormat = "yyyy-MM-dd"
////Get the result string:
//
//let result = formatter.string(from: dateReservation)
//
////Set your label:

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
