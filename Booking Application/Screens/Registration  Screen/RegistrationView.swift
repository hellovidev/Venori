//
//  RegistrationView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    
    var body: some View {
        ZStack {
            ZStack {
            VStack {
                Image("Registration Image").frame(maxWidth: .infinity, alignment: .top)
                Spacer()
            }
                RadialGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#EDEEF000")!), Color(UIColor(hex: "#E0E1E3FF")!)]), center: UnitPoint(x: 0.5, y: 0.28), startRadius: 130, endRadius: 190)
                    .ignoresSafeArea()
                RadialGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#EDEEF000")!), Color(UIColor(hex: "#E0E1E3FF")!)]), center: UnitPoint(x: 0.5, y: 0.28), startRadius: 130, endRadius: 1000)
                    .ignoresSafeArea()
            }

            
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        TextFieldView(data: $viewModel.name, placeholder: "Name", isPassword: false)
                        TextFieldView(data: $viewModel.surname, placeholder: "Surname", isPassword: false)
                    }
                    .padding(.bottom, 6)
                    Text(viewModel.inputNameErrorMessage)
                        .isHidden(viewModel.inputNameErrorMessage.isEmpty ? true : false, remove: viewModel.inputNameErrorMessage.isEmpty ? true : false)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.red)
                        .background(Color.yellow)
                        .padding(.bottom, 8)
                    TextFieldView(data: $viewModel.email, placeholder: "Email", isPassword: false)
                        .padding(.bottom,6)
                        .keyboardType(.emailAddress)
                    
//                    if !viewModel.hasEmailDomain {
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: -24) {
//                                ForEach(viewModel.emailProviders, id: \.self) { item in
//                                    Button(action: {
//                                        viewModel.email.append(item)
//                                    }) {
//                                        Text(item)
//                                            .foregroundColor(.black)
//                                            .padding([.top, .bottom], 8)
//                                            .padding([.leading, .trailing], 12)
//                                    }
//                                    .background(Color.white)
//                                    .cornerRadius(24)
//                                    .padding(.leading, 24)
//                                    .padding(.trailing, 8)
//                                }
//                            }
//                        }
//                        .padding(.bottom, 4)
//                        .ignoresSafeArea(edges: [.leading, .trailing])
//                    }
                    
                    Text(viewModel.inputEmailErrorMessage)
                        .isHidden(viewModel.inputEmailErrorMessage.isEmpty ? true : false, remove: viewModel.inputEmailErrorMessage.isEmpty ? true : false)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.red)
                        .background(Color.yellow)
                        .padding(.bottom, 4)
                    TextFieldView(data: $viewModel.password, placeholder: "Password", isPassword: true)
                        .padding(.bottom, 6)
                    TextFieldView(data: $viewModel.passwordRepeat, placeholder: "Repeat Password", isPassword: true)
                    Text(viewModel.inputPasswordErrorMessage)
                        .isHidden(viewModel.inputPasswordErrorMessage.isEmpty ? true : false, remove: viewModel.inputPasswordErrorMessage.isEmpty ? true : false)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.red)
                        .background(Color.yellow)
                        .padding(.bottom, 8)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                
                Button(action: {
                    self.hideKeyboard()
                    self.viewModel.tryRegister()
                }) {
                    Text("Sign up")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.top, 13)
                        .padding(.bottom, 13)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity)
                }
                .disabled(!viewModel.isValid)
                .background(viewModel.isValid ? Color("Button Color") : Color.gray)
                .cornerRadius(24)
                .padding(.leading, 75)
                .padding(.trailing, 75)
                .padding(.top, 16)
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 13, weight: .medium))
                    Button {
                        self.viewModel.controller?.redirectSignIn()
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel())
    }
}
