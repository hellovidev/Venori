//
//  TextFieldView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import SwiftUI

struct TextFieldView: View {
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
                        .resizable()
                        .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
                        .onTapGesture {
                            isPasswordShowing.toggle()
                        }
                } else {
                    TextField("", text: $data)
                        .font(.system(size: 24))
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .frame(maxHeight: 44, alignment: .center)
            .background(Color("Text Field Color"))
            .cornerRadius(8)
            .padding(2)
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
