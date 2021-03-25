//
//  CoreDataManager.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 25.03.2021.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() // Singleton. Will live forever as long as your application is still alive, it's properties will too
    
    let persistantContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RememberYourTripModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()
    

}
