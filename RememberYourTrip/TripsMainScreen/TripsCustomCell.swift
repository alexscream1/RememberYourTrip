//
//  TripsCustomCell.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 25.03.2021.
//

import UIKit

class TripsCustomCell: UITableViewCell {
    
    var trip : Trip? {
        didSet {
            guard let place = trip?.place else { return }
            tripLabel.text = place
            
            if let imageData = trip?.imageData {
                tripImageView.image = UIImage(data: imageData)
            }
            
            guard let money = trip?.moneySpend else { return }
            if money.isNumeric {
                moneyLabel.text = "\(money)$"
            } else {
                moneyLabel.text = "\(money)"
            }
            
            // Setup format of date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            guard let startDate = trip?.started else { return }
            startLabel.text = "Start - \(dateFormatter.string(from: startDate))"
            
            guard let endDate = trip?.finished else { return }
            endLabel.text = "End - \(dateFormatter.string(from: endDate))"
        }
    }
    
    let tripImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "select_photo_empty")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let tripLabel : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let startLabel : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let endLabel : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let moneyLabel : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tealColor
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(tripImageView)
        tripImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        tripImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tripImageView.layer.cornerRadius = 80 / 2
        
        addSubview(tripLabel)
        tripLabel.anchor(top: tripImageView.topAnchor, left: tripImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)

        addSubview(startLabel)
        startLabel.anchor(top: tripLabel.bottomAnchor, left: tripImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)

        addSubview(endLabel)
        endLabel.anchor(top: startLabel.bottomAnchor, left: tripImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)

        addSubview(moneyLabel)
        moneyLabel.anchor(top: endLabel.bottomAnchor, left: tripImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
