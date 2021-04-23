//
//  NavigationBarView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import SwiftUI

struct NavigationBarView<Content: View>: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var searchRequest: String = ""
    @State private var isSearchEditing: Bool = false
    @State private var active = false
    
    var isSearch: Bool
    
    var title: String
    let color : Color
    let content: Content
    
    let isRoot : Bool
    let isLast : Bool
    
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
                        
                        // MARK: -> Search Bar Block
                        
                        /*
                         if !isSearch && isSearchEditing {
                         SearchBarView(text: $searchRequest, isEditing: $isSearchEditing)
                         .padding(.top, -30)
                         }
                         
                         List(todoItems.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { item in
                         Text(item.name)
                         }
                         
                         // Dismiss the keyboard
                         UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                         */
                        
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
                        Spacer()
                            .isHidden(isRoot ? true : false, remove: true)
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .isHidden(isRoot ? true : false, remove: true)
                        Spacer()
                            .isHidden(isRoot ? true : false, remove: true)
                        Button {
                            // Location  Code
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
                            isSearchEditing = true
                            // Search Action
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
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: -> Extensitons For Hide Elements

/*
 Hide or show the view based on a boolean value.
 
 Example for visibility:
 Text("Label").isHidden(true)
 
 Example for complete removal:
 Text("Label").isHidden(true, remove: true)
 
 - Parameters:
 - hidden: Set to `false` to show the view. Set to `true` to hide the view.
 - remove: Boolean value indicating whether or not to remove the view.
 */

extension Text {
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
