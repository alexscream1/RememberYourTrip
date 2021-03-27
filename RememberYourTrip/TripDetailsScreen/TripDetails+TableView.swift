//
//  TripDetails+TableView.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 27.03.2021.
//

import UIKit

class CustomLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let customRect = rect.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        super.drawText(in: customRect)
    }
    
}

extension TripDetailsController {
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // TableView Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = CustomLabel()
        label.text = placesTypes[section]
        label.textAlignment = .center
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if allPlaces[section].isEmpty {
            return 0
        } else {
            return 50
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allPlaces.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlaces[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TripDetailsCustomCell
        
        let place = allPlaces[indexPath.section][indexPath.row]
        
        cell.place = place
        return cell
    }
}
