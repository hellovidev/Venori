//
//  BookView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct BookView: View {
    var body: some View {
        VStack{
            if true {
        Text("Book")
        
        Text("Reservation ID")
        Text("121231")
        
        HStack{
        VStack {
        Text("Expected date of arrival")
        Text("Today")
        }
            Image(systemName: "celender")
        }
        
        HStack{
        VStack {
        Text("Expected time of arrival")
        Text("16:55")
        }
            Image(systemName: "clock")
        }
        
        Text("Number of adults")
//        Stepper(value: 1, in: 5) {
//            Text("1")
//        }
        
        Text("Is this a Special Event?")
//        Toggle(isOn: false) {
//            Text("Hi")
//        }
        
            Text("How long will you be dining with us?")
//        Stepper(value: 1, in: 5) {
//            Text("1")
//        }
        
            Text("Available reservation times")
        //List {}
        
        //Button {} label: { Text("Continue") }
            
            
            
            Button(action: {
                //loginViewModel?.tryLogin()
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
        } else {
            Image(systemName: "Complete")
            Text("The table has been booked")
            Text("We’ll wait for you on time.")
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
        BookView()
    }
}
