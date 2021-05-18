//
//  AppDelegate.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    private let serviceAPI: ServerRequest = ServerRequest()
    @Published var locationManager: CLLocationManager?
    @Published var addressFull: String?
    
    func getAddressFromLatLon(completion: @escaping (Result<String, Error>) -> Void, pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude: pdblLatitude, longitude: pdblLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Reverse geodcode fail: \(error!.localizedDescription)")
                completion(.failure(error!))
            }
            
            guard placemarks != nil else {
                completion(.failure(error!))
                return
            }
            
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                let address: String = (placemark.country ?? "") // Some args more: + ", " + (placemark.locality ?? "") + ", " + (placemark.thoroughfare ?? "")
                UserDefaults.standard.set(address, forKey: "address_full")
                // Post notification about location data update
                NotificationCenter.default.post(name: .newLocationNotification, object: nil)
                completion(.success(address))
            }
        })
    }
    
    func sentUserLocation() {
        getAddressFromLatLon(completion: { result in
            switch result {
            case .success(let address):
                self.addressFull = address
                self.serviceAPI.sentCurrentUserLocation(completion: { result in
                    switch result {
                    case .success(let message):
                        print("Sent user location success: \(message)")
                    case .failure(let error):
                        
                        // Post notification about error location
                        
                        NotificationCenter.default.post(name: .newLocationErrorNotification, object: nil)
                        print("Sent user location faild: \(error.localizedDescription)")
                    }
                }, latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude"), address: address)
            case .failure(let error):
                
                // Post notification about error location
                
                NotificationCenter.default.post(name: .newLocationErrorNotification, object: nil)
                print("Sent user location faild: \(error.localizedDescription)")
            }
        }, pdblLatitude: UserDefaults.standard.double(forKey: "latitude"), withLongitude: UserDefaults.standard.double(forKey: "longitude"))
    }
    
    // MARK: -> User Location
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
                    UserDefaults.standard.set(locationValue.latitude, forKey: "latitude")
                    UserDefaults.standard.set(locationValue.longitude, forKey: "longitude")
                    UserDefaults.standard.synchronize()
                    self.sentUserLocation()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.removeObject(forKey: "latitude")
        UserDefaults.standard.removeObject(forKey: "longitude")
        UserDefaults.standard.removeObject(forKey: "address_full")
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Booking_Application")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
