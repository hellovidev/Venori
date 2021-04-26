//
//  BookView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct BookView: View {
    @ObservedObject var bookViewModel: BookViewModel
    var serviceAPI = ServiceAPI()
    
    @State private var isComplete: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if !isComplete {
                    BookProcessView(times: bookViewModel.avalClock, placeID: bookViewModel.placeID!, actionContinue: {
                        self.isComplete.toggle()
                    }, actionClose: {
                        self.bookViewModel.controller?.goBack()
                    })
//                    .onAppear {
//                        if ((serviceAPI.availableTimes?.isEmpty) != nil) {
//                            self.serviceAPI.reserveTablePlace(placeIdentifier: bookViewModel.placeID!, adultsAmount: 1, duration: 0.5, date: "2021-04-24", time: "17:00")
//                            bookViewModel.avalClock = serviceAPI.availableTimes!
//                        }
//                    }
            } else {
                CompleteView(actionContinue: {
                    self.bookViewModel.controller?.fullyComplete()
                }, actionBack: {
                    self.isComplete.toggle()
                })
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct CompleteView: View {
    var actionContinue: () -> Void
    var actionBack: () -> Void
    
    var body: some View {
        Button {
            self.actionBack()
        } label: {
            Image("Arrow Left")
                .padding([.top, .bottom, .trailing], 22)
                .padding(.leading, 16)
        }
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
        Button(action: {
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

struct BookProcessView: View {
    @State var valueHours: Float = 0.5
    @State var valueHumans: Float = 1
    @State var times: [String]
    @State var placeID: Int
    @State private var numberOfAdults = 1
    var actionContinue: () -> Void
    var actionClose: () -> Void
    
    var serviceAPI = ServiceAPI()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button {
                    self.actionClose()
                } label: {
                    Image("Close")
                        .padding([.top, .bottom, .trailing], 22)
                        .padding(.leading, 16)
                }
                
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
                    Button {
                        // Pick Calendar Action
                    } label: {
                        Image("Calendar")
                            .padding(.trailing, 16)
                    }
                }
                .padding(.bottom, 32)
                
                VStack(alignment: .leading) {
                    Text("Number of adults")
                        .font(.system(size: 18, weight: .regular))
                        .padding(.bottom, 12)
                    CustomStepperView(onClick: {
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
                    }, placeIdentifier: placeID, adultsAmount: Int(valueHumans), duration: valueHours, date: "2021-04-27")
    }, value: $valueHumans, valueType: "")
                    
                        .padding(.trailing, 16)
                }
                .padding(.leading, 16)
                .padding(.bottom, 32)
                
                VStack(alignment: .leading) {
                    Text("How long will you be dining with us?")
                        .font(.system(size: 18, weight: .regular))
                        .padding(.bottom, 12)
                    CustomStepperView(onClick: {
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
                        }, placeIdentifier: placeID, adultsAmount: Int(valueHumans), duration: valueHours, date: "2021-04-27")
                    }, value: $valueHours, valueType: "hr")
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
                                    
                                } label: {
                                    Text(object)
                                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                                        .padding([.top, .bottom], 12)
                                        .padding([.leading, .trailing], 16)
                                        .background(Color(UIColor(hex: "#F6F6F6FF")!))
                                        .cornerRadius(24)
                                        .padding(.leading, 16)
                                }
                            }
                        }

                    }
                }
                .padding(.bottom, 24)
                .onAppear {
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
                        
                    , placeIdentifier: placeID, adultsAmount: 1, duration: 0.5, date: "2021-04-26")
                }
                
                Spacer()
                Button(action: {
                    serviceAPI.reserveTablePlace(placeIdentifier: placeID, adultsAmount: Int(valueHumans), duration: valueHours, date: "2021-04-24", time: "12:00")
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
        BookView(bookViewModel: BookViewModel())
    }
}

struct CustomStepperView: View {
    var onClick: () -> Void
    @Binding var value: Float
    var valueType: String
    
    var serviceAPI = ServiceAPI()
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                if value > 1 && valueType != "hr" {
                    value -= 1
                    self.onClick()
                } else if value > 0.5 && valueType == "hr" {
                    value -= 0.5
                    self.onClick()
                }
            } label: {
                Image("Minus")
                    .padding([.top, .bottom], 12)
                    .padding(.leading, 16)
            }
            Spacer()
            if valueType != "hr" {
                Text("\(NSString(format: "%.0f", value))")
                    .font(.system(size: 22, weight: .regular))
            } else {
                Text("\(value)" + " " + valueType)
                    .font(.system(size: 22, weight: .regular))
            }
            Spacer()
            Button {
                if valueType == "hr" && value < 24 {
                    value += 0.5
                    self.onClick()
                } else if valueType != "hr" {
                    value += 1
                    self.onClick()
                }
            } label: {
                Image("Plus")
                    .padding([.top, .bottom], 12)
                    .padding(.trailing, 16)
            }
        }
        .background(Color(UIColor(hex: "#F6F6F6FF")!))
        .cornerRadius(24)
    }
}
