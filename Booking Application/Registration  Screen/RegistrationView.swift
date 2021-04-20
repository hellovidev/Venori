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
            VStack {
                Image("Registration Image").frame(maxWidth: .infinity, alignment: .top)
                Spacer()
            }
            .overlay(
                RadialGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#EDEEF000")!), Color(UIColor(hex: "#E0E1E3FF")!)]), center: UnitPoint(x: 0.5, y: 0.28), startRadius: 130, endRadius: 190)
                    .ignoresSafeArea()
            )
        }
        .overlay(
            VStack {
                Spacer()
                VStack {
                    CustomTextField(data: $registrationViewModel.email, placeholder: "Name", isPassword: false).padding(.bottom, 10)
                    CustomTextField(data: $registrationViewModel.email, placeholder: "Surname", isPassword: false).padding(.bottom, 10)
                    
                    CustomTextField(data: $registrationViewModel.email, placeholder: "Email", isPassword: false).padding(.bottom, 10)
                    CustomTextField(data: $registrationViewModel.password, placeholder: "Password", isPassword: true).padding(.bottom, 10)
                    CustomTextField(data: $registrationViewModel.passwordRepeat, placeholder: "Repeat Password", isPassword: true)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                Button(action: {
                    self.registrationViewModel.controller?.processSignUp()
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
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 13, weight: .medium))
                    Button {
                        self.registrationViewModel.controller?.redirectToSignIn()
                    } label: {
                        Text("Sign in")
                            .underline()
                            .font(.system(size: 13, weight: .medium))
                    }
                }
                .padding(.leading, 80)
                .padding(.trailing, 80)
                .padding(.top, 24)
            }
            .padding(.bottom, 20)
        )
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(registrationViewModel: RegistrationViewModel())
    }
}
