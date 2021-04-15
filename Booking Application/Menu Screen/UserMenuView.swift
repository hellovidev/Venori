//
//  MenuView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct UserMenuView: View {
    @ObservedObject var userMenuViewModel: UserMenuViewModel

    
    private let headerSection = ["Account details", "Booking history", "Favorites", "Notifications", "Settings"]
    private let footerSection = ["About", "Contact", "Terms", "Privacy Policy"]
    
    private let menuIcons = ["Menu Account", "Menu Booking", "Menu Favorites", "Menu Notifications", "Menu Settings"]
    
    var body: some View {
        VStack {
            ZStack {
                Image("Background Account")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: 256)
                VStack {
                    Image("User Logo")
                    Text("Alex Goldant!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 4)
                    Text("template@email.com")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.white)
                }
            }
            List {
                Section(footer: Spacer()) {
                    ForEach(headerSection, id: \.self) { item in
                        HStack(alignment: .center) {
                            Image(menuIcons[0])
                            Text("\(item)")
                            Spacer()
                            Image("Menu Vector")
                        }
                    }
                }
                Section(footer: Button {
                    print("Pressed!")
                } label: {
                    Text("Log out")
                }
                .padding(.top, 30)
                .foregroundColor(Color.blue))
                {
                    ForEach(footerSection, id: \.self) { item in
                        Text("\(item)")
                    }
                }
            }
        }
    }
}

struct UserMenuView_Previews: PreviewProvider {
    static var previews: some View {
        UserMenuView(userMenuViewModel: UserMenuViewModel())
    }
}


//struct CustomHeader: View {
//    let name: String
//    let color: Color
//
//    var body: some View {
//        VStack {
//            Spacer()
//            HStack {
//                Text(name)
//                Spacer()
//            }
//            Spacer()
//        }
//        .padding(0).background(FillAll(color: color))
//    }
//}
//
//struct FillAll: View {
//    let color: Color
//    
//    var body: some View {
//        GeometryReader { proxy in
//            self.color.frame(width: proxy.size.width * 1.3).fixedSize()
//        }
//    }
//}
