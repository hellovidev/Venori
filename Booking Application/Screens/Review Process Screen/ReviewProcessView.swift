//
//  ReviewProcessView.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import SwiftUI

struct ReviewProcessView: View {
    @ObservedObject var viewModel: ReviewProcessViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Button ( action:{
                viewModel.controller?.redirectPrevious()
            }, label: {
                Image("Close")
                    .padding([.top, .bottom, .trailing], 22)
                    .padding(.leading, 16)
            })
            Text("New review")
                .font(.system(size: 32, weight: .bold))
                .padding(.leading, 16)
                .padding(.bottom, 22)
            
            TextFieldReviewView(data: $viewModel.titleText, placeholder: "Title")
                .padding([.trailing, .leading], 16)
            
            Text("Description")
                .foregroundColor(Color.black)
                .font(.system(size: 18))
                .padding([.trailing, .leading], 20)
            
                TextEditor(text: $viewModel.descriptionText)
                    .font(.system(size: 18))
                    .frame(maxHeight: 96, alignment: .center)
                    .border(Color.gray, width: 1)
                    .padding(3)

            .padding([.trailing, .leading], 16)
            RatingView(rating: $viewModel.rating)
                .padding([.trailing, .leading], 16)
                .padding([.top, .bottom], 12)
            Button(action: {
                viewModel.publishNewReview(title: viewModel.titleText, rating: viewModel.rating!, description: viewModel.descriptionText)
            }) {
                Text("Publish")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.top, 13)
                    .padding(.bottom, 13)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity)
                    .shadow(radius: 10)
                .background(!viewModel.isValid ? Color.gray : Color("Button Color"))
            }
            .disabled(!viewModel.isValid)
            .modifier(ButtonModifier())
            .padding(.bottom, 35)
            Spacer()
        }
         .ignoresSafeArea(.keyboard)
        .onTapGesture {
            self.hideKeyboard()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlert = false }))
        }
    }
}

struct RatingView: View {
    @Binding var rating: Int?
    private let max: Int = 5
    
    var body: some View {
        HStack {
            ForEach(1..<(max + 1), id: \.self) { index in
                Image(systemName: self.starType(index: index))
                    .resizable()
                    .frame(maxWidth: 32, maxHeight: 30)
                    .foregroundColor(Color.yellow)
                    .onTapGesture {
                        self.rating = index
                    }
            }
        }
    }
    
    private func starType(index: Int) -> String {
        if let rating = self.rating {
            return index <= rating ? "star.fill" : "star"
        } else {
            return "star"
        }
    }
}

struct TextFieldReviewView: View {
    @Binding var data: String
    var placeholder: String
    
    @State private var isPasswordShowing: Bool = false
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $data)
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
            
            Divider()
                .frame(height: 1)
                .padding(.horizontal, 30)
                .background(Color.gray)
        }
        .frame(maxHeight: 48, alignment: .center)
        .padding(3)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
