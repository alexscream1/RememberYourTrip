//
//  TripsController+CreateTrip.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 26.03.2021.
//

import UIKit

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
