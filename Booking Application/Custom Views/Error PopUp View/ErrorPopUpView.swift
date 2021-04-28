//
//  ErrorPopUpView.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import SwiftUI

struct ErrorPopUpView: View {
    var title: String
    var message: String
    @Binding var show: Bool

    var body: some View {
        ZStack {
            if show {
                
                // Background Color of PopUp View
                
                Color.black.opacity(show ? 0.5 : 0).edgesIgnoringSafeArea(.all)
                
                // PopUp Window
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Error")
                            .frame(maxWidth: .infinity)
                            .frame(height: 45, alignment: .center)
                            .font(Font.system(size: 22, weight: .semibold))
                            .foregroundColor(Color.white)
                            .background(Color.red)
                        Text(message)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 16, weight: .semibold))
                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                            .foregroundColor(Color.white)
                    }
                    .frame(maxWidth: 300)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    Button(action: {
                        // Dismiss the PopUp
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
                    .background(Color.red)
                    .cornerRadius(24)
                }
            }
        }
    }
}

//struct ErrorPopUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorPopUpView(title: "Error", message: "Big Error")
//    }
//}
