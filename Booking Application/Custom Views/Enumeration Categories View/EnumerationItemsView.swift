//
//  EnumerationItemsView.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import Foundation
import SwiftUI

struct EnumerationCategoriesView: View {
    var items: [Category]
    @State var selected = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -8) {
                ForEach(items, id: \.self) { item in
                    ItemCategoryView(category: item, selectedButtonIdentifier: self.$selected)
                }
            }
        }
    }
}

struct ItemCategoryView: View {
    var category: Category
    @Binding var selectedButtonIdentifier: Int
    
    var body: some View{
        Button(action: {
            self.selectedButtonIdentifier = self.category.id
        }) {
            Text(category.name)
                .foregroundColor(self.selectedButtonIdentifier == self.category.id ? Color.white : Color(UIColor(hex: "#00000080")!))
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 16)
        }
        .background(self.selectedButtonIdentifier == self.category.id ? Color.blue : Color(UIColor(hex: "#F6F6F6FF")!))
        .cornerRadius(24)
        .padding(.leading, 16)
    }
}


//        .shadow(radius: 10)


//struct EnumerationItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnumerationItemsView()
//    }
//}


//struct MainView: View {
//
//    let boxes:[Box] = [
//    Box(id: 0, title: "Home"),
//    Box(id: 1, title: "Subjects"),
//    Box(id: 2, title: "attendence"),
//    Box(id: 3, title: "H.W"),
//    Box(id: 4, title: "Quizes"),
//    Box(id: 5, title: "class schedule"),
//    Box(id: 6, title: "Exam Schedule"),
//    Box(id: 7, title: "Inbox"),
//    Box(id: 8, title: "Evalouation"),
//    ]
//
//  //@Binding var showMenu: Bool
//  @State var selected = 0    // 1
//  var body: some View{
//    VStack {
//      ScrollView(.horizontal,showsIndicators: false){
//        HStack{
//          ForEach(boxes, id: \.id) { box in
//            ItemView(box: box, selectedBtn: self.$selected)  // 2
//          }
//        }
//      }
//    }
//    .padding()
//  }
//}
//
//
//
//struct Box: Identifiable  {
//    var id: Int
//    var title: String
//}
//
//struct EnumerationItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}


//class Bar: BindableObject {
//    let didChange = PassthroughSubject<Void, Never>()
//
//    let   name: String
//    init(name aName: String) {
//        name = aName
//    }
//}
//
//class Foo: Bar {
//    let value: Int
//    init(name aName: String, value aValue: Int) {
//        value = aValue
//        super.init(name:aName)
//    }
//}



//let arrayOfFoos = [ Foo(name:"Alpha",value:12), Foo(name:"Beta",value:13)]
//    .map(AnyBindable.init)
//
//struct ContentView : View {
//    var body: some View {
//        VStack {
//            ForEach(arrayOfFoos) { aFoo in
//                Text("\(aFoo.name) = \(aFoo.value)")    // it compiles now
//            }
//        }
//    }
//}
