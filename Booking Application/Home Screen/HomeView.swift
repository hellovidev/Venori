//
//  HomeView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
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
                    Text("NOTHING")
                } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: -8) {
                        ForEach(0..<10) {
                            Text("Item \($0)")
                            RestarauntCardView()
                                .padding(.leading, 16)
                                .onTapGesture {
                                    print("Pressed!")
                                }
                        }
                    }
                }
                }
            }
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
                            Text("Item \($0)")
                            RestarauntCardView()
                                .padding(.leading, 16)
                                .onTapGesture {
                                    print("Pressed!")
                                }
                        }
                    }
                }
            }
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
                            CategoryView(title: "\($0)", imageName: "Text Field Show")
                                .padding(.leading, 16)
                                .onTapGesture {
                                    print("Pressed!")
                                }
                        }
                    }
                }
            }
        }
    }
}

struct RestarauntCardView: View {
    var body: some View {
        VStack {
            Image("Background Account")
                .overlay(Image(systemName: "heart"))
            Text("Title")
            HStack {
                Image(systemName: "star")
                Text("4.2 (634)")
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
                .resizable()
                .frame(maxWidth: 44, maxHeight: 44, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
                .padding(32)
                .background(Color("Category Background"))
                .clipShape(Circle())
            Text(title).font(.system(size: 17, weight: .medium))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
