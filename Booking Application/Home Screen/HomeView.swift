//
//  HomeView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            
            
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("My Favorite Restaraunts").font(.system(size: 22, weight: .semibold)).padding(.leading, 16)
                            Spacer()
                            Button {
                                print("Pressed!")
                            } label: {
                                Text("See all")
                            }
                            .padding(.trailing, 16)
                        }
                        if true {
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#3A7DFF2E")!)]), startPoint: .top, endPoint: .bottom)
                                    .cornerRadius(32)
                                    .padding(.trailing, 16)
                                    .padding(.leading, 16)
                                VStack {
                                    Image("Heart")
                                    Text("asdasddfsdfsdfsdfdsfsdfdsfsdfsdfsdfsdfsdfsdfsdfsdfsdfdsfdsjkfhsfjsdhfksdfhdskfhdskfdsfhsdffdsfdsfdsfjkhdsklfdsjfkdsfjdsfjsdfdsjfsdfjklsdfjklsdasdasd")
                                    
                                }
                            }

                                
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: -8) {
                                    ForEach(0..<10) {
                                        Text("Item \($0)")
                                        RestarauntCardView(title: "Bar Veranda", rating: Float($0),votes: 2354)
                                            .padding(.leading, 16)
                                            .onTapGesture {
                                                print("Pressed!")
                                            }
                                    }
                                }
                            }
                        }
                    }.padding(.bottom, 26)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Restaurants").font(.system(size: 22, weight: .semibold)).padding(.leading, 16)
                            Spacer()
                            Button {
                                print("Pressed!")
                            } label: {
                                Text("See all")
                            }
                            .padding(.trailing, 16)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -8) {
                                ForEach(0..<10) {
                                    RestarauntCardView(title: "Bar Veranda", rating: Float($0),votes: 2354)
                                        .padding(.leading, 16)
                                        .onTapGesture {
                                            print("Pressed!")
                                        }
                                }
                            }
                        }
                    }.padding(.bottom, 26)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Food Categories").font(.system(size: 22, weight: .semibold)).padding(.leading, 16)
                            Spacer()
                            Button {
                                print("Pressed!")
                            } label: {
                                Text("See all")
                            }
                            .padding(.trailing, 16)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -8) {
                                ForEach(1...10, id: \.self) {
                                    CategoryView(title: "\($0) + Title", imageName: "Burger")
                                        .padding(.leading, 16)
                                        .onTapGesture {
                                            print("Pressed!")
                                        }
                                }
                            }
                        }
                    }.padding(.bottom, 26)
                }
            }.navigationBarTitle(Text("Location"))
        }
    }
}

struct RestarauntCardView: View {
    var title: String
    var rating: Float
    var votes: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("Background Account")
                .cornerRadius(32)
                .overlay(
                    Image("Heart").resizable()
                        .frame(maxWidth: 48, maxHeight: 48)
                        .offset(x: 140, y: -90)
                )
            
            Text(title)
                .bold()
            HStack {
                Image("Star")
                Text("\(NSString(format: "%.0f", self.rating))")
                Text("\(self.votes)").foregroundColor(.gray)
            }
            
        }
    }
}

struct CategoryView: View {
    var title: String
    var imageName: String
    
    var body: some View {
        VStack{
            Image(imageName)
                //.resizable()
                .frame(maxWidth: 44, maxHeight: 44, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
                .padding(32)
                .background(Color(UIColor(hex: "#3A7DFF2E")!))
                .clipShape(Circle())
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .bold()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
