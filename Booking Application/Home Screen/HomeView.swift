//
//  HomeView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var categories: [Category] = [Category(title: "Burger", image: "Burger"), Category(title: "Pizza", image: "Burger"), Category(title: "Sushi", image: "Burger")]
    var restaurants: [Restaurant] = [Restaurant(title: "Bar Cuba", image: "Background Account", rating: 4.2, votes: 23512), Restaurant(title: "Hookah Place", image: "Background Account", rating: 3.2, votes: 154), Restaurant(title: "Restaurant Barashka", image: "Background Account", rating: 5, votes: 5678)]
    
    var body: some View {
        CustomNavigationView(title: "", isRoot: true, isSearch: true, isLast: false, color: .white, onBackClick: {}) {
            ScrollView {
                VStack {
                    
                    // MARK: Favorite Restaurants Block
                    
                    VStack(alignment: .leading) {
                        SectionView(title: "My Favorite Restaraunts", onClick: { })
                        if true {
                            FavouriteEmptyView()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: -8) {
                                    ForEach(restaurants, id: \.self) { object in
                                        RestarauntCardView(title: object.title, rating: object.rating, votes: object.votes, backgroundImage: object.image, onClick: {})
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 26)
                    
                    // MARK: Restaurants Block
                    
                    VStack(alignment: .leading) {
                        SectionView(title: "Restaurants", onClick: {
                                        homeViewModel.controller?.seeAllRestaraunts()
                        })
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -8) {
                                ForEach(restaurants, id: \.self) { object in
                                    RestarauntCardView(title: object.title, rating: object.rating, votes: object.votes, backgroundImage: object.image, onClick: {})
                                }
                            }
                        }
                    }
                    .padding(.bottom, 26)
                    
                    // MARK: Categories Block
                    
                    VStack(alignment: .leading) {
                        SectionView(title: "Food Categories", onClick: {
                            homeViewModel.controller?.seeAllCategories()
                        })
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -8) {
                                ForEach(categories, id: \.self) { object in
                                    CategoryView(title: object.title, imageName: object.image, onClick: {}).padding(.leading, 16)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 26)
                }
            }
        }
    }
}

// MARK: -> Horizontal List Block

//struct HListView: View {
//    var objects: AnyObject
//    var onElementClick: () -> Void
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: -8) {
//                ForEach(objects, id: \.self) { object in
//                    CategoryView(title: object.title, imageName: object.image, onClick: {})
//                }
//            }
//        }
//    }
//}
//
//struct HListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HListView(data: { title: "Burger", imageName: "Burger" }, onElementClick: {})
//    }
//}

// MARK: -> Restaraunt Card View

struct RestarauntCardView: View {
    var title: String
    var rating: Float
    var votes: Int
    var backgroundImage: String
    var onClick: () -> Void
    
    var body: some View {
        Button { } label: {
            VStack(alignment: .leading) {
                ZStack {
                    Image(backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 296, maxHeight: 169)
                        .cornerRadius(32)
                    VStack {
                        Image("Heart")
                            .resizable()
                            .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color(UIColor(hex: "#0000007A")!))
                            .clipShape(Circle())
                            .padding(.trailing, 9)
                            .padding(.top, 9)
                        Spacer()
                    }
                    .frame(maxWidth: 296, maxHeight: 169, alignment: .trailing)
                }
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 10)
                    .padding(.bottom, -4)
                    .foregroundColor(.black)
                HStack {
                    Image("Star")
                    Text("\(NSString(format: "%.01f", self.rating))")
                        .foregroundColor(.black)
                    Text("(\(String(self.votes)))")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.leading, 16)
    }
}

struct RestarauntCardView_Previews: PreviewProvider {
    static var previews: some View {
        RestarauntCardView(title: "Bar Cuba", rating: 2.6, votes: 5362, backgroundImage: "Background Account", onClick: {})
    }
}

// MARK: -> Category View

struct CategoryView: View {
    var title: String
    var imageName: String
    var onClick: () -> Void
    
    var body: some View {
        Button {
            self.onClick()
        } label: {
            VStack {
                Image(imageName)
                    .resizable()
                    .frame(maxWidth: 44, maxHeight: 44, alignment: .center)
                    .foregroundColor(.white)
                    .padding(32)
                    .background(Color(UIColor(hex: "#3A7DFF2E")!))
                    .clipShape(Circle())
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(title: "Burger", imageName: "Burger", onClick: {})
    }
}

// MARK: -> If Block Of Favourite Restaraunts Is Empty

struct FavouriteEmptyView: View {
    var body: some View {
        ZStack {
            Color(UIColor(hex: "#3A7DFF2E")!)
                .cornerRadius(32)
                .padding(.trailing, 16)
                .padding(.leading, 16)
            VStack {
                Image("Heart")
                    .frame(maxWidth: 44, maxHeight: 44, alignment: .center)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color(UIColor(hex: "#3A7DFF2E")!))
                    .clipShape(Circle())
                    .padding(.top, 23)
                    .padding(.bottom, 8)
                Text("Press heart icon on any restaurant to add into your favorites")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 23)
                    .padding(.leading, 32)
                    .padding(.trailing, 32)
                    .foregroundColor(Color(UIColor(hex: "#0000004D")!))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 169)
    }
}

struct FavouriteEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteEmptyView()
    }
}

// MARK: -> Section For View All Elements Of List

struct SectionView: View {
    var title: String
    var onClick: () -> Void
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .padding(.leading, 16)
            Spacer()
            Button {
                self.onClick()
            } label: {
                HStack(alignment: .center) {
                    Text("See all")
                        .font(.system(size: 18, weight: .regular))
                    Image("Arrow")
                }
            }
            .padding(.trailing, 16)
        }
        .padding(.bottom, 9)
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Category", onClick: {})
    }
}

// MARK: -> Summary View Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeViewModel: HomeViewModel())
    }
}












// MARK: -> Some Code

//struct ContentView: View {
//    var body: some View {
//        CustomNavigationView(destination: FirstView(), isRoot: true, isLast: false, color: .blue){
//            Text("This is the Root View")
//        }
//    }
//}
//
//struct FirstView : View {
//    var body: some View {
//        CustomNavigationView(destination: SecondView(), isRoot: false, isLast: false, color: .red){
//            Text("This is the First View")
//        }
//    }
//}
//
//struct SecondView : View {
//    var body: some View {
//        CustomNavigationView(destination: LastView(), isRoot: false, isLast: false, color: .green){
//            Text("This is the Second View")
//        }
//    }
//}
//
//struct LastView : View {
//    var body: some View {
//        CustomNavigationView(destination: EmptyView(), isRoot: false, isLast: true, color: .yellow){
//            Text("This is the Last View")
//        }
//    }
//}

//struct CustomNavigationView<Content: View, Destination : View>: View {
//    let destination : Destination
//    let isRoot : Bool
//    let isLast : Bool
//    let color : Color
//    let content: Content
//    @State var active = false
//    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
//
//    init(destination: Destination, isRoot : Bool, isLast : Bool,color : Color, @ViewBuilder content: () -> Content) {
//        self.destination = destination
//        self.isRoot = isRoot
//        self.isLast = isLast
//        self.color = color
//        self.content = content()
//    }
//
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                Color.white
//                VStack {
//                    ZStack {
//                        WaveShape()
//                            .fill(color.opacity(0.3))
//                        HStack {
//                                Image(systemName: "arrow.left")
//                                    .frame(width: 30)
//                                .onTapGesture(count: 1, perform: {
//                                    self.mode.wrappedValue.dismiss()
//                                }).opacity(isRoot ? 0 : 1)
//                            Spacer()
//                            Image(systemName: "command")
//                                .frame(width: 30)
//                            Spacer()
//                            Image(systemName: "arrow.right")
//                                .frame(width: 30)
//                                .onTapGesture(count: 1, perform: {
//                                    self.active.toggle()
//                                })
//                                .opacity(isLast ? 0 : 1)
//                            NavigationLink(
//                                destination: destination.navigationBarHidden(true)
//                                    .navigationBarHidden(true),
//                                isActive: self.$active,
//                                label: {
//                                    //no label
//                                })
//                        }
//                        .padding([.leading,.trailing], 8)
//                        .frame(width: geometry.size.width)
//                        .font(.system(size: 22))
//
//                    }
//                    .frame(width: geometry.size.width, height: 90)
//                    .edgesIgnoringSafeArea(.top)
//
//                    Spacer()
//                    self.content
//                        .padding()
//                        .background(color.opacity(0.3))
//                        .cornerRadius(20)
//                    Spacer()
//                }
//            }.navigationBarHidden(true)
//        }
//    }
//}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


struct CustomNavigationView<Content: View>: View {
    let isRoot : Bool
    let isLast : Bool
    let color : Color
    let content: Content
    @State var active = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    let isSearch: Bool
    var title: String
    var onBackClick: () -> Void
    
    init(title: String, isRoot : Bool, isSearch: Bool, isLast : Bool,color : Color, onBackClick: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isRoot = isRoot
        self.isSearch = isSearch
        self.isLast = isLast
        self.color = color
        self.content = content()
        self.onBackClick = onBackClick
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack(alignment: .center) {
                        
                        Button {
                            self.onBackClick()
                            self.mode.wrappedValue.dismiss()
                            //self.$active
                        } label: {
                            Image("Arrow Left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 24, alignment: .center)
                                .padding([.bottom, .top], 13)
                                .padding(.leading, 19)
                                .foregroundColor(.black)
                        }
                        .isHidden(isRoot ? true : false, remove: true)
                        //.opacity(isRoot ? 0 : 1)
                        
                            
//                            .onTapGesture(count: 1, perform: {
//
//                            })
                        Spacer()
                            .isHidden(isRoot ? true : false, remove: true)
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .isHidden(isRoot ? true : false, remove: true)
                        Spacer()
                            .isHidden(isRoot ? true : false, remove: true)
                        Button {
                            //location code
                        }  label: {
                            Image("Pin")
                                .padding([.leading, .top, .bottom], 16)
                                .padding(.trailing, 6)
                            VStack(alignment: .leading) {
                                Text("Location")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(UIColor(hex: "#00000080")!))
                                    .padding(.bottom, -8)
                                HStack(alignment: .center) {
                                    Text("Current location")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18, weight: .bold))
                                    Image("Vector")
                                }
                            }
                        }
                        .isHidden(isRoot ? false : true, remove: true)
                        Spacer()
                        .isHidden(isRoot ? false : true, remove: true)
                        Button {
                            //action search
                        } label: {
                            Image("Search")
                        }
                        .isHidden(!isSearch)
                        .padding(.top, 12)
                        .padding(.trailing, 16)
                        .padding(.bottom, 12)
                    }
                    
                    .frame(width: geometry.size.width, height: 48)
                    self.content
                        .background(color.opacity(1))
                        //.ignoresSafeArea()

                }
            }
            .navigationBarHidden(true)

        }
    }
}


extension Text {
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension Image {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension Spacer {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension Button {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
