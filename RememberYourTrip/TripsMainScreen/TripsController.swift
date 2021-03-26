//
//  ViewController.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 24.03.2021.
//

import UIKit
import CoreData

let cellID = "cellID"

class TripsController: UITableViewController {

    var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trips = CoreDataManager.shared.fetchTrips()
        
        view.backgroundColor = .white
        
        tableView.register(TripsCustomCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        
        navigationItem.title = "Trips"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddTrip))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Remove all", style: .plain, target: self, action: #selector(handleRemoveAll))
        
        setupNavBarStyle()
    }
    
    // Remove all trips button pressed
    @objc private func handleRemoveAll() {
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Trip.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathToRemove = [IndexPath]()
            
            for (index, _) in trips.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            trips.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .fade)
            
        } catch let err {
            print("Failed to delete trips:", err)
        }
    }
    
    // Add trip button pressed
    @objc fileprivate func handleAddTrip() {
        let vc = CreateTripController()
        vc.delegate = self
        let navController = CustomNavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}

