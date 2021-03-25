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
        
        fetchTrips()
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        
        navigationItem.title = "Trips"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddTrip))
        
        setupNavBarStyle()
    }
    
    // Fetch trips from core data
    private func fetchTrips() {
        
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
        
        do {
            let fetchTrips = try context.fetch(fetchRequest)
            fetchTrips.forEach { (trip) in
                print(trip.place ?? "")
            }
            self.trips = fetchTrips
            self.tableView.reloadData()
            
        } catch let error {
            print("Failed to fetch data:", error)
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
    
    
    // Edit action for table view row
    private func editHandlerFunction(indexPath: IndexPath) {
        let createTripController = CreateTripController()
        createTripController.delegate = self
        createTripController.trip = trips[indexPath.row]
        let navController = CustomNavigationController(rootViewController: createTripController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete action for row
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
            let trip = self.trips[indexPath.row]
            
            // Remove from table view
            self.trips.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
            // Remove from core data
            let context = CoreDataManager.shared.persistantContainer.viewContext
            
            context.delete(trip)
            
            do {
                try context.save()
            } catch let error {
                print("Failed to save data", error)
            }
        }
        
        // Edit action for row
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            self.editHandlerFunction(indexPath: indexPath)
        }
        
        // Set actions colors
        editAction.backgroundColor = .darkBlue
        deleteAction.backgroundColor = .lightRed
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

        return swipeActions
    }

    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let trip = trips[indexPath.row]
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.text = trip.place
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
}

extension TripsController: CreateTripControllerDelegate {
    
    
    func didEditTrip(trip: Trip) {
        guard let index = trips.firstIndex(of: trip) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
    
    func didSaveTrip(trip: Trip) {
        self.trips.append(trip)
        let indexPath = IndexPath(row: trips.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
}


