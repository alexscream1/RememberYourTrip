//
//  ViewController.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 24.03.2021.
//

import UIKit

let cellID = "cellID"

class TripsController: UITableViewController {

    var trips = [
        Trip(place: "Istanbul Trip", started: Date()),
        Trip(place: "New York Trip", started: Date()),
        Trip(place: "Portugal Trip", started: Date())
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        
        navigationItem.title = "Trips"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddTrip))
        
        setupNavBarStyle()
        
        
        
    }
    
    @objc fileprivate func handleAddTrip() {
        let vc = CreateTripController()
        vc.delegate = self
        let navController = CustomNavigationController(rootViewController: vc)
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
    
    func saveTrip(trip: Trip) {
        self.trips.append(trip)
        let indexPath = IndexPath(row: trips.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
