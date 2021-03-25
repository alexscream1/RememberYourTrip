//
//  CreateTripController.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 24.03.2021.
//

import UIKit
import CoreData

protocol CreateTripControllerDelegate {
    func didSaveTrip(trip: Trip)
    func didEditTrip(trip: Trip)
}

class CreateTripController: UIViewController {
    
    var delegate : CreateTripControllerDelegate?
    
    var trip : Trip? {
        didSet {
            placeTextField.text = trip?.place
        }
    }
    
    let placeLabel : UILabel = {
        let label = UILabel()
        label.text = "Place"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let placeTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter trip place"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Create Trip"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
        
        setupNavBarStyle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = trip == nil ? "Create Trip" : "Edit Trip"
    }
    
    @objc private func cancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButton() {
        
        if trip == nil {
            createTrip()
        } else {
            saveTripChanges()
        }
        
    }
    
    private func createTrip() {
        // Initialize Core Data Stack
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let trip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context)
        
        trip.setValue(placeTextField.text, forKey: "place")
        
        // Perform save to core data
        do {
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didSaveTrip(trip: trip as! Trip)
            }
            
        } catch let saveError {
            print("Failed to save data: ", saveError)
        }
    }
    
    private func saveTripChanges() {
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        trip?.place = placeTextField.text
        
        do {
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didEditTrip(trip: self.trip!)
            }
        } catch let error {
            print("Failed to save data:", error)
        }
        
    }
    
    private func setupUI() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightBlue
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(placeLabel)
        placeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        placeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        placeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(placeTextField)

        placeTextField.leftAnchor.constraint(equalTo: placeLabel.rightAnchor).isActive = true
        placeTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        placeTextField.topAnchor.constraint(equalTo: placeLabel.topAnchor).isActive = true
        placeTextField.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor).isActive = true
        
    }
}
