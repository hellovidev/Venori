//
//  LoginView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack {
            VStack {
                Image("Splash Image").frame(maxWidth: .infinity, alignment: .top)
                Spacer()
            }
            .overlay(
                RadialGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#D6DDE700")!), Color(UIColor(hex: "#DAE1EBFF")!)]), center: UnitPoint(x: 0.5, y: 0.33), startRadius: 140, endRadius: 220)
                    .ignoresSafeArea()
            )
        }
        .overlay(
            VStack {
                Spacer()
                VStack {
                    CustomTextField(data: $loginViewModel.email, placeholder: "Email", isPassword: false).padding(.bottom, 10)
                    CustomTextField(data: $loginViewModel.password, placeholder: "Password", isPassword: true)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                Button(action: {
                    //self.loginViewModel.controller?.processSignIn()
                    self.loginViewModel.controller?.authComplete()
                    //loginViewModel?.tryLogin()
                }) {
                    Text("Sign in")
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
                    Text("Don’t have an account?")
                        .font(.system(size: 13, weight: .medium))
                    Button {
                        self.loginViewModel.controller?.redirectToSignUp()
                    } label: {
                        Text("Sign up")
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

struct CustomTextField: View {
    @Binding var data: String
    var placeholder: String
    var isPassword: Bool
    
    @State private var isPasswordShowing: Bool = false
    
    var body: some View {
        VStack {
            Text(placeholder).modifier(TextFieldPlaceholderModifier())
            HStack{
                if isPassword {
                    if isPasswordShowing {
                        TextField("", text: $data)
                            .font(.system(size: 24))
                    } else {
                        SecureField("", text: $data)
                            .font(.system(size: 24))
                    }
                    Image(isPasswordShowing ? "Text Field Hide" : "Text Field Show")
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
                        .onTapGesture {
                            isPasswordShowing.toggle()
                        }
                } else {
                    TextField("", text: $data)
                        .font(.system(size: 24))
                        .textCase(.lowercase)
                }
            }
            .padding()
            .frame(maxHeight: 48, alignment: .center)
            .background(Color("Text Field Color"))
            .cornerRadius(8)
            .padding(3)
            .foregroundColor(.black)
        }
    }
}

struct TextFieldPlaceholderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13, weight: .regular))
            .frame(maxWidth: .infinity, maxHeight: 18, alignment: .leading)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginViewModel: LoginViewModel())
    }
}
