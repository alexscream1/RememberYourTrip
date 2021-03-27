//
//  CoreDataManager.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 25.03.2021.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() // Singleton. Will live forever as long as your application is still alive, it's properties will too
    
    let persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RememberYourTripModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()
    
    // Fetch trips from core data
    func fetchTrips() -> [Trip] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
        
        do {
            let fetchTrips = try context.fetch(fetchRequest)
            return fetchTrips
            
        } catch let error {
            print("Failed to fetch data:", error)
            return []
        }
    }
    
    func saveTripDetails(place: String, impression: String, type: String, trip: Trip) -> (Details?, Error?) {
        let context = persistentContainer.viewContext
        
        let details = NSEntityDescription.insertNewObject(forEntityName: "Details", into: context) as! Details
        
        details.trip = trip
        details.setValue(place, forKey: "place")
        details.setValue(impression, forKey: "impression")
        details.setValue(type, forKey: "type")
        
        do {
            try context.save()
            return (details, nil)
        } catch let error {
            print(error)
            return (nil, error)
        }
        
    }
}


