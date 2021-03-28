//
//  TripDetailsController+SaveDetails.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 26.03.2021.
//

import UIKit

extension TripDetailsController: CreateDetailsControllerDelegate {
    
    // Calls when dismiss create details
    func didSaveDetails(detail: Details) {
        
        guard let index = detail.type else { return }
        guard let section = placesTypes.firstIndex(of: index) else { return }
        let row = allPlaces[section].count
        
        let insertionIndexPath = IndexPath(row: row, section: section)
        
        allPlaces[section].append(detail)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
}

extension CreateDetailsController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
