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
                if serviceAPI.$availableTimes != nil {
                    BookProcessView(times: bookViewModel.avalClock, actionContinue: {
                        serviceAPI.reserveTablePlace(placeIdentifier: 1)
                        self.isComplete.toggle()
                    }, actionClose: {
                        self.bookViewModel.controller?.goBack()
                    })
                    .onAppear {
                        if ((serviceAPI.availableTimes?.isEmpty) != nil) {
                            self.serviceAPI.reserveTablePlace(placeIdentifier: 1)
                            bookViewModel.avalClock = serviceAPI.availableTimes!
                        }
                    }
                }
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
    @State private var valueHours: Float = 0.5
    @State private var valueHumans: Float = 1
    @State var times: [String]
    
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
                    Text("121231")
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
                    CustomStepperView(value: $valueHumans, valueType: "")
                        .padding(.trailing, 16)
                }
                .padding(.leading, 16)
                .padding(.bottom, 32)
                
                VStack(alignment: .leading) {
                    Text("How long will you be dining with us?")
                        .font(.system(size: 18, weight: .regular))
                        .padding(.bottom, 12)
                    CustomStepperView(value: $valueHours, valueType: "hr")
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
                        .onAppear {
                            self.serviceAPI.getPlaceAvailableTime(placeIdentifier: 1)
                        }
                    }
                }
                .padding(.bottom, 24)
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
    @Binding var value: Float
    var valueType: String
    
    var serviceAPI = ServiceAPI()
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                if value > 0 && valueType != "hr" {
                    value -= 1
                } else if value > 0 && valueType == "hr" {
                    value -= 0.5
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
                } else if valueType != "hr" {
                    value += 1
                    serviceAPI.getPlaceAvailableTime(placeIdentifier: 1)
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
