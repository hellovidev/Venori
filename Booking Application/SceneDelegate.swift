//
//  SceneDelegate.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let api = ServiceAPI()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        //let contentView = //HomeView()//LoginView(loginViewModel: LoginViewModel()).environment(\.managedObjectContext, context)
        //@Environment(\.presentationMode) var presentationMode

        /*
         let tabController = UITabBarController()
         let popular = PopularViewController()
         let search = SearchViewController()
         
         popular.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "film"), tag: 0)
         search.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
         
         let controllers = [popular, search]
         tabController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
         
         if !state.isAuth {
             currentWindow.rootViewController = LoginViewController()
         } else {
             currentWindow.rootViewController = tabController
         }
         */
        // Email: qqqqq@gmail.com, Password: qqqqqqqqq

        //
        //func getYearReleaseDate() -> String {
        //    return String(date?.prefix(4) ?? "")
        //}
        //api.loadCategoriesData()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            if UserDefaults.standard.string(forKey: "access_token") != nil {                
                let tabController = UITabBarController()
                
                let home = HomeViewController()
                let orders = OrdersViewController()
                let more = UserMenuViewController()
                
                home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Tab Home"), tag: 0)
                orders.tabBarItem = UITabBarItem(title: "Orders", image: UIImage(named: "Tab Bag"), tag: 0)
                more.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "Tab More"), tag: 1)
                
                home.tabBarItem.selectedImage = UIImage(named: "Active Home")
                orders.tabBarItem.selectedImage = UIImage(named: "Active Bag")
                more.tabBarItem.selectedImage = UIImage(named: "Active More")
                
                let controllers = [home, orders, more]
                tabController.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
                
                tabController.tabBar.barTintColor = .white
                tabController.tabBar.clipsToBounds = true
                
                //navigationController.isNavigationBarHidden = true

                window.rootViewController = tabController
                window.makeKeyAndVisible()
            } else {
                window.rootViewController = LoginViewController()
            }
            
            //window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}







// MARK: -> Some Code



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





// MARK: -> Other Code













//    func loadCategoriesData() {
//        guard let url = URL(string: Requests.domainLink.rawValue + Requests.categoriesRouter.rawValue) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) {data, response, error in
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode(Categories.self, from: data) {
//                    DispatchQueue.main.async {
//                        self.categories = decodedResponse
//                    }
//                    return
//                }
//            }
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//
//        }.resume()
//    }


//    private let url = URL(string: Requests.domainLink.rawValue + Requests.categoriesRouter.rawValue)
//
//
//
//    func loadData() -> AnyPublisher<[Category], Error> {
//        return URLSession.shared.dataTaskPublisher(for: self.url!)
//            .map(\.data)
//            .decode(type: Categories.self, decoder:  JSONDecoder())
//            .map(\.data)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//













//            //             let finalData = try! JSONDecoder().decode(ServerResponse.self, from: data)
//            //             print(finalData)
//            //             DispatchQueue.main.async{
//            //             if finalData.error == "Unauthorized"{
//            //             self.authenticated = false
//            //             }
//            //             }
































//        var request = URLRequest(url: URL(string:  "http://dev2.cogniteq.com:3110/api/login?")!)
//            request.httpMethod = "POST"
//
//
////            let postString =  String(format: "email=%@&password=%@", arguments: [txt_emailVirify.text!, language!])
////            print(postString)
////
////            emailString = txt_emailVirify.text!
//
//            request.httpBody = postString.data(using: .utf8)
//            request.addValue("delta141forceSEAL8PARA9MARCOSBRAHMOS", forHTTPHeaderField: "Authorization")
//            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data, error == nil
//                    else
//                {
//                    print("error=\(String(describing: error))")
//                    return
//                }
//
//                do
//                {
//
//                    let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
//                    print(dictionary)
//
//                    let status = dictionary.value(forKey: "status") as! String
//                    let sts = Int(status)
//                    DispatchQueue.main.async()
//                        {
//                            if sts == 200
//                            {
//                                print(dictionary)
//
//
//                            }
//                            else
//                            {
//                               self.alertMessageOk(title: self.Alert!, message: dictionary.value(forKey: "message") as! String)
//
//
//                            }
//                    }
//                }
//                catch
//                {
//                    print(error)
//                }
//
//            }
//            task.resume()
//


//    //private let url = URL(string: APIRequests.dataResource.rawValue + APIRequests.prefixKeyAPI.rawValue + APIRequests.keyAPI.rawValue)!
//    //private let loginURL = URL(string: "http://dev2.cogniteq.com:3110/api/login")
//
//    func getTokenAuth() {
//        let defaults = UserDefaults.standard
//        defaults.set("token", forKey: "access_token")
//
//        // Prepare URL
//        let url = URL(string: "http://dev2.cogniteq.com:3110/api/login?email=asdas&password=asdas")
//        guard let requestUrl = url else { fatalError() }
//        // Prepare URL Request Object
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "POST"
//
//        // HTTP Request Parameters which will be sent in HTTP Request Body
//        let postString = "userId=300&title=My urgent task&completed=false";
//        // Set HTTP Request Body
//        request.httpBody = postString.data(using: String.Encoding.utf8);
//        // Perform HTTP Request
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//                // Check for Error
//                if let error = error {
//                    print("Error took place \(error)")
//                    return
//                }
//
//                // Convert HTTP Response Data to a String
//                if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                    print("Response data string:\n \(dataString)")
//                }
//        }
//        task.resume()
//
//    }
//
//
//
//}



