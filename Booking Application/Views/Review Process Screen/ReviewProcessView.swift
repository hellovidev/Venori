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
        ZStack {
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
                Text("Title")
                    .foregroundColor(Color.black)
                    .font(.system(size: 18))
                    .padding([.trailing, .leading], 20)
                TextFieldReviewView(data: $viewModel.titleText, placeholder: "")
                    .padding([.trailing, .leading, .bottom], 16)
                Text("Description")
                    .foregroundColor(Color.black)
                    .font(.system(size: 18))
                    .padding([.trailing, .leading], 20)
                TextEditor(text: $viewModel.descriptionText)
                    .font(.system(size: 18))
                    .frame(maxHeight: 82, alignment: .center)
                    .border(Color.gray, width: 1)
                    .padding(3)
                    .padding([.trailing, .leading, .bottom], 16)
                Text("Rating")
                    .foregroundColor(Color.black)
                    .font(.system(size: 18))
                    .padding([.trailing, .leading], 20)
                RatingView(rating: $viewModel.rating)
                    .padding([.trailing, .leading], 16)
                Spacer()
                Button(action: {
                    viewModel.publishNewReview(title: viewModel.titleText, rating: viewModel.rating!, description: viewModel.descriptionText)
                }, label:{
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
                })
                .disabled(!viewModel.isValid)
                .modifier(ButtonModifier())
                .padding(.bottom, 35)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)

            
            if viewModel.isLoading {
                ZStack {
                    Color(UIColor(hex: "#FFFFFF99")!)
                    ProgressView()
                }
                .ignoresSafeArea()
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
        }
        .frame(maxHeight: 42, alignment: .center)
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
        .border(Color.gray, width: 1)
    }
    
}
