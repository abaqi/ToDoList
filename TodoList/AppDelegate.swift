//
//  AppDelegate.swift
//  TodoList
//
//  Created by MacBook Pro on 06/09/2019.
//  Copyright © 2019 abc. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //The functionality UserDefaults offers is very convenient and hence very dangerous.
        //When people start getting into saving collections arrays of large amounts of data, it becomes unmanageable.
        //UserDefaults is not a database and it should not be used as a database! Entire plist will be loaded whenever UserDeffaults is called.
        //Using it too much can bring down your apps efficiency
        //User Defaults is a SINGLETON
        //Singleton: Only one copy of these can be shared across all of your classes and objects (static type?)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

