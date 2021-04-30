//
//  MenuView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct MoreView: View {
    @ObservedObject var viewModel: MoreViewModel
    private let serviceAPI = ServiceAPI()
    //private let user: User = UserDefaults.standard.object(forKey: "current_user") as! User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                ZStack {
                    Image("Background Account")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: 256)
                    VStack {
                        ImageURL(url: DomainRouter.generalDomain.rawValue + (viewModel.user?.avatar ?? ""))
                            .frame(maxWidth: 96, maxHeight: 96, alignment: .center)
                            .scaledToFill()
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        Text("\(viewModel.user?.firstName ?? "User") \(viewModel.user?.secondName ?? "Account")")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color.white)
                            .padding(.bottom, 4)
                        Text(viewModel.user?.email ?? "Haven't Email")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color.white)
                    }
                }
                Group {
                    MenuItemView(item: MenuItems.account.rawValue, image: MenuIcons.accountIcon.rawValue, decorateItem: true, onClick: {})
                        .padding(.top, 20)
                    MenuItemView(item: MenuItems.history.rawValue, image: MenuIcons.historyIcon.rawValue, decorateItem: true, onClick: {
                        self.viewModel.controller?.redirectToBookingHistory()
                    })
                    MenuItemView(item: MenuItems.favorites.rawValue, image: MenuIcons.favoritesIcon.rawValue, decorateItem: true, onClick: {})
                    MenuItemView(item: MenuItems.notifications.rawValue, image: MenuIcons.notificationsIcon.rawValue, decorateItem: true, onClick: {})
                    MenuItemView(item: MenuItems.settings.rawValue, image: MenuIcons.settingsIcon.rawValue, decorateItem: true, onClick: {})
                        .padding(.bottom, 20)
                }
                Group {
                    MenuItemView(item: MenuItems.about.rawValue, image: "", decorateItem: false, onClick: {})
                    MenuItemView(item: MenuItems.contact.rawValue, image: "", decorateItem: false, onClick: {})
                    MenuItemView(item: MenuItems.terms.rawValue, image: "", decorateItem: false, onClick: {})
                    MenuItemView(item: MenuItems.privacy.rawValue, image: "", decorateItem: false, onClick: {})
                        .padding(.bottom, 30)
                }
                MenuItemView(item: MenuItems.logout.rawValue, image: "", decorateItem: false, onClick: {
                    self.serviceAPI.userAccountLogout( completion: { result in
                        switch result {
                        case .success(let message):
                            print(message)
                            self.viewModel.controller?.systemLogout()
                        case .failure(let error):
                            print(error)
                        }
                    })
                })
                .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

struct UserMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(viewModel: MoreViewModel())
    }
}

struct MenuItemView: View {
    let item: String
    let image: String
    let decorateItem: Bool
    let onClick: () -> Void
    
    var body: some View {
        VStack {
            Button (action: {
                self.onClick()
            }, label: {
                HStack(alignment: .top) {
                    Image(image)
                        .isHidden(!self.decorateItem, remove: !self.decorateItem)
                        .padding(.leading, 16)
                        .padding([.top, .bottom], 6)
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text(item)
                                .foregroundColor(item == "Log out" ? .blue : .black)
                                .font(.system(size: 14, weight: .regular))
                            Spacer()
                            Image("Menu Vector")
                                .isHidden(!self.decorateItem, remove: !self.decorateItem)
                                .padding(.trailing, 16)
                        }
                        Divider()
                    }
                    .padding(.leading, 16)
                    .padding([.top, .bottom], 6)
                }
            })
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

public enum MenuItems: String {
    case account = "Account details"
    case history = "Booking history"
    case favorites = "Favorites"
    case notifications = "Notifications"
    case settings = "Settings"
    case about = "About"
    case contact = "Contact"
    case terms = "Terms"
    case privacy = "Privacy Policy"
    case logout = "Log out"
}

public enum MenuIcons: String {
    case accountIcon = "Menu Account"
    case historyIcon = "Menu Booking"
    case favoritesIcon = "Menu Favorites"
    case notificationsIcon = "Menu Notifications"
    case settingsIcon = "Menu Settings"
}
