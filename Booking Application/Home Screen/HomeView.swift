//
//  HomeView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        CustomNavigationView(destination: FirstView(), isRoot: true, isLast: false, color: .white) {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        SectionView(title: "My Favorite Restaraunts", onClick: {})
                        if true {
                            FavouriteEmptyView()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: -8) {
                                    ForEach(0..<10) {
                                        Text("Item \($0)")
                                        RestarauntCardView(title: "Bar Veranda", rating: Float($0),votes: 2354)
                                        
                                    }
                                }
                            }
                        }
                    }.padding(.bottom, 26)
                    VStack(alignment: .leading) {
                        SectionView(title: "Restaurants", onClick: {})
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -8) {
                                ForEach(0..<10) {
                                    RestarauntCardView(title: "Bar Veranda", rating: Float($0),votes: 2354)
                                }
                            }
                        }
                    }.padding(.bottom, 26)
                    VStack(alignment: .leading) {
                        SectionView(title: "Food Categories", onClick: {})
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -8) {
                                ForEach(1...10, id: \.self) {
                                    CategoryView(title: "\($0) + Title", imageName: "Burger", onClick: {})
                                    
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

struct RestarauntCardView: View {
    var title: String
    var rating: Float
    var votes: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Image("Background Account")
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
            HStack {
                Image("Star")
                Text("\(NSString(format: "%.01f", self.rating))")
                Text("(\(String(self.votes)))")
                    .foregroundColor(.gray)
            }
        }
        .padding(.leading, 16)
        .onTapGesture {
            print("Pressed Card!")
        }
    }
}

struct RestarauntCardView_Previews: PreviewProvider {
    static var previews: some View {
        RestarauntCardView(title: "Bar Cuba", rating: 2.6, votes: 5362)
    }
}

struct CategoryView: View {
    var title: String
    var imageName: String
    var onClick: () -> Void
    
    var body: some View {
        VStack{
            Image(imageName)
                .resizable()
                .frame(maxWidth: 44, maxHeight: 44, alignment: .center)
                .foregroundColor(.white)
                .padding(32)
                .background(Color(UIColor(hex: "#3A7DFF2E")!))
                .clipShape(Circle())
            Text(title)
                .font(.system(size: 17, weight: .semibold))
        }
        .padding(.leading, 16)
        .onTapGesture {
            self.onClick()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(title: "Burger", imageName: "Burger", onClick: {})
    }
}

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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: -> Some Code

struct ContentView: View {
    var body: some View {
        CustomNavigationView(destination: FirstView(), isRoot: true, isLast: false, color: .blue){
            Text("This is the Root View")
        }
    }
}

struct FirstView : View {
    var body: some View {
        CustomNavigationView(destination: SecondView(), isRoot: false, isLast: false, color: .red){
            Text("This is the First View")
        }
    }
}

struct SecondView : View {
    var body: some View {
        CustomNavigationView(destination: LastView(), isRoot: false, isLast: false, color: .green){
            Text("This is the Second View")
        }
    }
}

struct LastView : View {
    var body: some View {
        CustomNavigationView(destination: EmptyView(), isRoot: false, isLast: true, color: .yellow){
            Text("This is the Last View")
        }
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CustomNavigationView<Content: View, Destination : View>: View {
    let destination : Destination
    let isRoot : Bool
    let isLast : Bool
    let color : Color
    let content: Content
    @State var active = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(destination: Destination, isRoot : Bool, isLast : Bool,color : Color, @ViewBuilder content: () -> Content) {
        self.destination = destination
        self.isRoot = isRoot
        self.isLast = isLast
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    //                        HStack {
                    //
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
                    
                    
                    HStack(alignment: .center) {
                        
                        Image(systemName: "arrow.left")
                            .isHidden(isRoot ? true : false, remove: true)
                            .frame(width: 18)
                            .padding([.bottom, .top], 13)
                            .padding(.leading, 19)
                            
                            .onTapGesture(count: 1, perform: {
                                self.mode.wrappedValue.dismiss()
                            }).opacity(isRoot ? 0 : 1)
                        Spacer()
                            .isHidden(isRoot ? true : false, remove: true)
                        Text("Restaurants")
                            .font(.system(size: 18, weight: .bold))
                            .isHidden(isRoot ? true : false, remove: true)
                        Spacer()
                            .isHidden(isRoot ? true : false, remove: true)
                        HStack {
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
                                    .font(.system(size: 18, weight: .bold))
                                Image("Vector")
                            }
                        }
                        }
                        .onTapGesture {
                            //location code
                        }
                        Spacer()
                        Button {
                            //action search
                        } label: {
                            Image("Search")
                        }
                        .padding(.top, 12)
                        .padding(.trailing, 16)
                        .padding(.bottom, 12)
                    }
                    .frame(width: geometry.size.width, height: 60)
                    
                    self.content
                        .background(color.opacity(1))
                        .ignoresSafeArea()
                }
            }.navigationBarHidden(true)
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
