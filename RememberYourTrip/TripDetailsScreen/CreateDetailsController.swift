//
//  CreateDetailsController.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 26.03.2021.
//

import UIKit

protocol CreateDetailsControllerDelegate {
    func didSaveDetails(detail: Details)
}

class CreateDetailsController: UIViewController {
    
    var delegate: CreateDetailsControllerDelegate?
    
    var trip: Trip?
    
    let placeLabel : UILabel = {
        let label = UILabel()
        label.text = "Name:"
        return label
    }()
    
    let placeTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter name of place"
        return tf
    }()
    
    let commentLabel : UILabel = {
        let label = UILabel()
        label.text = "Comment:"
        return label
    }()
    
    let commentTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your impression"
        return tf
    }()
    
    let placeSegmentedControl : UISegmentedControl = {
        let items = [
            PlacesTypes.Sightseeing.rawValue,
            PlacesTypes.Food.rawValue,
            PlacesTypes.Other.rawValue
        ]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkBlue
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        setupNavBarStyle()
        setupCancelButton()
        setupSaveButton(selector: #selector(handleSave))
        
        setupUI()
        
        navigationItem.title = "Create new place"
    }
    
    @objc func handleSave() {
        guard let place = placeTextField.text else { return }
        guard let comment = commentTextField.text else { return }
        guard let trip = trip else { return }
        guard let placeType = placeSegmentedControl.titleForSegment(at: placeSegmentedControl.selectedSegmentIndex) else { return }
        
        if place == "" {
            showError(title: "Empty Form", message: "You have not entered a name of place")
            return
        }
        
        
        let tuple = CoreDataManager.shared.saveTripDetails(place: place, impression: comment, type: placeType, trip: trip)
        
        if let error = tuple.1 {
            //present some AlertController
            print(error)
        } else {
            dismiss(animated: true) {
                guard let details = tuple.0 else { return }
                self.delegate?.didSaveDetails(detail: details)
            }
        }
    }
    
    
    private func setupUI() {
        _ = setupBackgroundView(height: 170)
        
        // Name place label
        view.addSubview(placeLabel)
        placeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
        
        // Name place textfield
        view.addSubview(placeTextField)
        placeTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: placeLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        placeTextField.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor).isActive = true
        placeTextField.delegate = self
        
        // Comment place label
        view.addSubview(commentLabel)
        commentLabel.anchor(top: placeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
        
        // Comment place textfield
        view.addSubview(commentTextField)
        commentTextField.anchor(top: placeTextField.bottomAnchor, left: commentLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        commentTextField.centerYAnchor.constraint(equalTo: commentLabel.centerYAnchor).isActive = true
        commentTextField.delegate = self
        
        // Place Segmented control
        view.addSubview(placeSegmentedControl)
        placeSegmentedControl.anchor(top: commentLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 35)
    
    }
}
