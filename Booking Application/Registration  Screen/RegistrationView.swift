//
//  RegistrationView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var registrationViewModel: RegistrationViewModel

    var body: some View {
        VStack {
            Image("Registration Image").frame(maxWidth: .infinity, alignment: .top)
            VStack {
                VStack {
                    CustomTextField(data: $registrationViewModel.email, placeholder: "Email", isPassword: false).padding(.bottom, 10)
                    CustomTextField(data: $registrationViewModel.password, placeholder: "Password", isPassword: true).padding(.bottom, 10)
                    CustomTextField(data: $registrationViewModel.passwordRepeat, placeholder: "Repeat Password", isPassword: true)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                Button(action: {
                    //loginViewModel?.tryLogin()
                }) {
                    Text("Sign up")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.top, 13)
                        .padding(.bottom, 13)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                }
                .background(Color("Button Color"))
                .cornerRadius(24)
                .padding(.leading, 75)
                .padding(.trailing, 75)
                .padding(.top, 16)
                Text("Already have an account? Sign in")
                    .padding(.leading, 80)
                    .padding(.trailing, 80)
                    .padding(.top, 24)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.bottom, 60)
            
            .ignoresSafeArea()
        }        .background(RadialGradient(gradient: Gradient(colors: [Color("Start Point Registration"), Color("End Point Registration")]), center: UnitPoint(x: 0.5, y: 0.3), startRadius: 180, endRadius: 600).ignoresSafeArea())
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(registrationViewModel: RegistrationViewModel())
    }
}
