//
//  TripsController+TableView.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 26.03.2021.
//

import UIKit

extension TripsController {
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trip = trips[indexPath.row]
        let tripDetailsController = TripDetailsController()
        tripDetailsController.trip = trip
        navigationController?.pushViewController(tripDetailsController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete action for row
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
            let trip = self.trips[indexPath.row]
            
            // Remove from table view
            self.trips.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
            // Remove from core data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
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
    
    // Edit action for table view row
    private func editHandlerFunction(indexPath: IndexPath) {
        let createTripController = CreateTripController()
        createTripController.delegate = self
        createTripController.trip = trips[indexPath.row]
        let navController = CustomNavigationController(rootViewController: createTripController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    // TableView Footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "No trips are available\n\nPress plus button to add new trip"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return trips.count == 0 ? 150 : 0
    }
    

    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TripsCustomCell
        
        let trip = trips[indexPath.row]
        cell.trip = trip
           
        return cell
    }
}


