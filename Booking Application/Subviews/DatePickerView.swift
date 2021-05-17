//
//  DatePickerView.swift
//  Booking Application
//
//  Created by student on 3.05.21.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var orderDateReservation: Date
    @Binding var show: Bool
    var onSelected: () -> Void
    
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
                        self.onSelected()
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
