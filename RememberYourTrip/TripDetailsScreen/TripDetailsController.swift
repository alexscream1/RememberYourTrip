//
//  TripDetailsController.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 26.03.2021.
//

import UIKit
import CoreData


class TripDetailsController: UITableViewController {

    let cellId = "CellID"
    var trip : Trip?
    var allPlaces = [[Details]]()
    let placesTypes = [
        PlacesTypes.Sightseeing.rawValue,
        PlacesTypes.Food.rawValue,
        PlacesTypes.Other.rawValue
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Add place"
        view.backgroundColor = .darkBlue
        
        setupPlusButton(selector: #selector(addTripDetails))
        
        tableView.register(TripDetailsCustomCell.self, forCellReuseIdentifier: cellId)
        
        fetchDetails()
    }
    
    
    
    private func fetchDetails() {
        
        guard let tripPlaces = trip?.details?.allObjects as? [Details] else { return }
        
        allPlaces = []
        
        // Filter trip places by type
        placesTypes.forEach { (placeType) in
            allPlaces.append(
                tripPlaces.filter({$0.type == placeType})
            )
        }
    }
    
    @objc private func addTripDetails() {
        let createDetailsController = CreateDetailsController()
        let navController = CustomNavigationController(rootViewController: createDetailsController)
        createDetailsController.delegate = self
        createDetailsController.trip = self.trip
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    
}
