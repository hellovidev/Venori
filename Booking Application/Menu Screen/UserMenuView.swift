//
//  MenuView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct UserMenuView: View {
    private let headerSection = ["Account details", "Booking history", "Favorites", "Notifications", "Settings"]
    private let footerSection = ["About", "Contact", "Terms", "Privacy Policy"]
    
    var body: some View {
        VStack {
            ZStack {
                Image("Background Account")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .ignoresSafeArea()
                VStack {
                    Image("User Logo")
                    Text("Alex Goldant!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.white)
                    padding(.bottom, 4)
                    Text("template@email.com")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.white)
                }
                
            }
            List {
                Section() {
                    ForEach(headerSection, id: \.self) { item in
                        HStack {
                            Image(systemName: "heart")
                            Text("\(item)")
                            Spacer()
                            Image(systemName: "link")
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
        UserMenuView()
    }
}
