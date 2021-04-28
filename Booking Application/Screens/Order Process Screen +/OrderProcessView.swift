//
//  BookView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

// MARK: -> Constructor Booking Process View

struct OrderProcessView: View {
    @ObservedObject var viewModel: OrderProcessViewModel
    @State private var isComplete: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if !isComplete {
                BookProcessView(times: viewModel.availableTime, placeID: viewModel.placeID!, actionContinue: {
                    self.isComplete.toggle()
                }, actionClose: {
                    self.viewModel.controller?.backToPlace()
                })
            } else {
                CompleteView(actionContinue: {
                    self.viewModel.controller?.completeOrderProcess()
                }, actionBack: {
                    self.isComplete.toggle()
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: -> Complete Booking Process View

struct CompleteView: View {
    var actionContinue: () -> Void
    var actionBack: () -> Void
    
    var body: some View {
        Button (action: {
            self.actionBack()
        }, label: {
            Image("Arrow Left")
                .padding([.top, .bottom, .trailing], 22)
                .padding(.leading, 16)
        })
        VStack(alignment: .center) {
            Image("Complete")
                .padding(.bottom, 65)
            Text("The table has been booked")
                .font(.system(size: 22, weight: .bold))
                .padding(.bottom, 16)
            Text("We’ll wait for you on time.")
                .font(.system(size: 20, weight: .regular))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        Spacer()
        Button (action: {
            self.actionContinue()
        }, label: {
            Text("Continue")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .semibold))
                .padding(.top, 13)
                .padding(.bottom, 13)
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity)
                .shadow(radius: 10)
        })
        .modifier(ButtonModifier())
        .padding(.bottom, 35)
    }
}

// MARK: -> Booking Process View

struct BookProcessView: View {
    @State var valueHours: Float = 0.5
    @State var valueHumans: Float = 1
    @State var times: [String]
    @State var placeID: Int
    @State private var numberOfAdults = 1
    var actionContinue: () -> Void
    var actionClose: () -> Void
    
    var serviceAPI: ServiceAPI = ServiceAPI()
    
    @State private var selectedReservationTime: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button ( action:{
                    self.actionClose()
                }, label: {
                    Image("Close")
                        .padding([.top, .bottom, .trailing], 22)
                        .padding(.leading, 16)
                })
                
                Text("Book a table")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.leading, 16)
                    .padding(.bottom, 22)
                
                VStack(alignment: .leading) {
                    Text("Reservation ID")
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .font(.system(size: 14, weight: .regular))
                    Text("\(Int.random(in: 1..<10000))")
                        .font(.system(size: 18, weight: .regular))
                }
                .padding(.leading, 16)
                .padding(.bottom, 32)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Expected date of arrival")
                            .foregroundColor(Color(UIColor(hex: "#00000080")!))
                            .font(.system(size: 14, weight: .regular))
                        Text("Today")
                            .font(.system(size: 18, weight: .regular))
                    }
                    .padding(.leading, 16)
                    Spacer()
                    Button (action: {
                        // Pick Calendar Action
                    }, label: {
                        Image("Calendar")
                            .padding(.trailing, 16)
                    })
                }
                .padding(.bottom, 32)
                
                VStack(alignment: .leading) {
                    Text("Number of adults")
                        .font(.system(size: 18, weight: .regular))
                        .padding(.bottom, 12)
                    StepperView(value: $valueHumans, valueType: "", onClick: {
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        //Give the format you want to the formatter:
                        
                        formatter.dateFormat = "yyyy-MM-dd"
                        //Get the result string:
                        
                        let result = formatter.string(from: date)
                        
                        serviceAPI.getPlaceAvailableTime(completion: { result in
                            switch result {
                            case .success(let times):
                                self.times = times
                            case .failure(let error):
                                print(error)
                            //                                    DispatchQueue.main.async {
                            //                                        viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
                            //                                      }
                            }
                        }, placeIdentifier: placeID, adultsAmount: Int(valueHumans), duration: valueHours, date: result)
                    })
                    
                    .padding(.trailing, 16)
                }
                .padding(.leading, 16)
                .padding(.bottom, 32)
                
                VStack(alignment: .leading) {
                    Text("How long will you be dining with us?")
                        .font(.system(size: 18, weight: .regular))
                        .padding(.bottom, 12)
                    StepperView(value: $valueHours, valueType: "hr", onClick: {
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        //Give the format you want to the formatter:
                        
                        formatter.dateFormat = "yyyy-MM-dd"
                        //Get the result string:
                        
                        let result = formatter.string(from: date)
                        
                        //Set your label:
                        
                        serviceAPI.getPlaceAvailableTime(completion: { result in
                            switch result {
                            case .success(let times):
                                self.times = times
                            case .failure(let error):
                                print(error)
                            //                                    DispatchQueue.main.async {
                            //                                        viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
                            //                                      }
                            }
                        }, placeIdentifier: placeID, adultsAmount: Int(valueHumans), duration: valueHours, date: result)
                    })
                    .padding(.trailing, 16)
                }
                .padding(.leading, 16)
                .padding(.bottom, 32)
                
                VStack(alignment: .leading) {
                    Text("Available reservation times")
                        .font(.system(size: 18, weight: .regular))
                        .padding(.leading, 16)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: -8) {
                            ForEach(times, id: \.self) { object in
                                Button {
                                    //selectedReservationTime = true
                                } label: {
                                    Text(object)
                                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                                        .padding([.top, .bottom], 12)
                                        .padding([.leading, .trailing], 16)
                                        .background(Color(UIColor(hex: "#F6F6F6FF")!))
                                        .cornerRadius(24)
                                        .padding(.leading, 16)
                                }
                                //.disabled(selectedReservationTime)
                            }
                        }
                        
                    }
                }
                .padding(.bottom, 24)
                .onAppear {
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    //Give the format you want to the formatter:
                    
                    formatter.dateFormat = "yyyy-MM-dd"
                    //Get the result string:
                    
                    let result = formatter.string(from: date)
                    
                    //Set your label:
                    
                    self.serviceAPI.getPlaceAvailableTime(completion: {
                        
                        result in
                        switch result {
                        case .success(let times):
                            self.times = times
                        case .failure(let error):
                            print(error)
                        //                                                DispatchQueue.main.async {
                        //                                                    self.viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
                        //                                                  }
                        }
                    }
                    
                    , placeIdentifier: placeID, adultsAmount: 1, duration: 0.5, date: result)
                }
                
                Spacer()
                Button(action: {
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    //Give the format you want to the formatter:
                    
                    formatter.dateFormat = "yyyy-MM-dd"
                    //Get the result string:
                    
                    let result = formatter.string(from: date)
                    
                    //Set your label:
                    
                    serviceAPI.reserveTablePlace(placeIdentifier: placeID, adultsAmount: Int(valueHumans), duration: valueHours, date: result, time: "12:00")
                    self.actionContinue()
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.top, 13)
                        .padding(.bottom, 13)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                }
                .modifier(ButtonModifier())
                .padding(.bottom, 35)
            }
        }
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("Button Color"))
            .cornerRadius(24)
            .padding(.leading, 75)
            .padding(.trailing, 75)
            .padding(.top, 16)
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderProcessView(viewModel: OrderProcessViewModel())
    }
}
