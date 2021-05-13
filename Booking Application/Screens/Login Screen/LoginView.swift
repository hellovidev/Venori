//
//  LoginView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    VStack {
                        Image("Splash Image")
                        Spacer()
                    }
                    RadialGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#D6DDE700")!), Color(UIColor(hex: "#DAE1EBFF")!)]), center: UnitPoint(x: 0.5, y: 0.33), startRadius: 140, endRadius: 220)
                        .ignoresSafeArea()
                    RadialGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#D6DDE700")!), Color(UIColor(hex: "#DAE1EBFF")!)]), center: UnitPoint(x: 0.5, y: 0.33), startRadius: 140, endRadius: 1000)
                        .ignoresSafeArea()
                }
            }
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    TextFieldView(data: $viewModel.email, placeholder: "Email", isPassword: false)
                        .padding(.bottom, 8)
                    Text(viewModel.inputErrorMessage)
                        .isHidden(viewModel.inputErrorMessage.isEmpty ? true : false, remove: viewModel.inputErrorMessage.isEmpty ? true : false)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.red)
                        .background(Color.yellow)
                        .padding(.bottom, 8)
                    TextFieldView(data: $viewModel.password, placeholder: "Password", isPassword: true)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                Button(action: {
                    self.hideKeyboard()
                    self.viewModel.tryAuthorize()
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
                .disabled(!viewModel.isValid)
                .background(viewModel.isValid ? Color("Button Color") : Color.gray)
                .cornerRadius(24)
                .padding(.leading, 75)
                .padding(.trailing, 75)
                .padding(.top, 16)
                HStack {
                    Text("Don’t have an account?")
                        .font(.system(size: 13, weight: .medium))
                    Button {
                        self.viewModel.controller?.redirectSignUp()
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
            .padding(.bottom, 25)
            
            if viewModel.isLoading {
                ZStack {
                    Color(UIColor(hex: "#FFFFFF99")!)
                    ProgressView()
                }
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlert = false }))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
