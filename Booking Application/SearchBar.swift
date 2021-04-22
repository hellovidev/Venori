//
//  SearchBar.swift
//  Booking Application
//
//  Created by student on 22.04.21.
//

import SwiftUI
 
struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }

 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
 
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                //.transition(.move(edge: .trailing))
                .animation(.default)
            }
        }

    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}

//
//Using the Search Bar for Data Filtering
//
//Now that the search bar is ready for use, let’s switch over to ContentView.swift and add the search bar to the list view.
//
//Right before the List view, insert the following code:
//
//
//1
//2
//SearchBar(text: $searchText)
//    .padding(.top, -30)
//This will add the search bar between the title and the list view. The searchText is a state variable for holding the search text. As the user types in the search field, this variable will be updated accordingly.
//
//To filter the result, you will need to update the List view like this:
//
//
//1
//2
//3
//List(todoItems.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { item in
//    Text(item.name)
//}
//In the code, we use the filter function to search for those to-do items which matches the search term. In the closure, we first check if the search text has a value. If not, we simply return true, which means that it returns all the items. Otherwise, we check if the name field contains the search term.
//
//Run the app to try out the search. It should filter the to-do item as you type.
//
//swiftui-search-bar-typing
//Dismissing the Keyboard
//
//As you can see, it’s not hard to create our own search bar entirely using SwiftUI. While the search bar is working, there is a minor issue we have to fix. Have you tried to tap the cancel button? It does clear the search field. However, the software keyboard is not dismissed.
//
//To fix that, we need to add a line of code in the action block of the Cancel button:
//
//
//1
//2
//// Dismiss the keyboard
//UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//In the code, we call the sendAction method to resign the first responder and dismiss the keyboard. You can now run the app using a simulator. When you tap the cancel button, it should clear the search field and dismiss the software keyboard.
//
