//
//  CreateTripController.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 24.03.2021.
//

import UIKit

protocol CreateTripControllerDelegate {
    func saveTrip(trip: Trip)
}

class CreateTripController: UIViewController {
    
    var delegate : CreateTripControllerDelegate?
    
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
    
    @objc private func cancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButton() {
        dismiss(animated: true) {
            guard let text = self.placeTextField.text, text != "" else { return }
            let trip = Trip(place: text, started: Date())
            self.delegate?.saveTrip(trip: trip)
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
