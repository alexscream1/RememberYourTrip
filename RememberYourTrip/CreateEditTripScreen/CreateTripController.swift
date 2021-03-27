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
            guard let place = trip?.place else { return }
            placeTextField.text = place
            
            guard let startedDate = trip?.started else { return }
            startedDatePicker.date = startedDate
            
            guard let finishedDate = trip?.started else { return }
            finishedDatePicker.date = finishedDate
            
            guard let money = trip?.moneySpend else { return }
            moneyTextField.text = String(money)
            
            if let imageData = trip?.imageData {
                tripImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
            
        }
    }
    
    let placeLabel : UILabel = {
        let label = UILabel()
        label.text = "Place"
        return label
    }()
    
    let placeTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter trip place"
        return tf
    }()
    
    let moneyLabel : UILabel = {
        let label = UILabel()
        label.text = "Money"
        return label
    }()
    
    let moneyTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter money that you spend"
        return tf
    }()
    
    let startedDatePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    let finishedDatePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    lazy var tripImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Create Trip"
        
        setupSaveButton(selector: #selector(saveButton))
        setupCancelButton()
        setupNavBarStyle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = trip == nil ? "Create Trip" : "Edit Trip"
    }
    
    
    @objc private func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let trip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context)
        
        trip.setValue(placeTextField.text, forKey: "place")
        trip.setValue(startedDatePicker.date, forKey: "started")
        trip.setValue(finishedDatePicker.date, forKey: "finished")
        trip.setValue(moneyTextField.text, forKey: "moneySpend")
        
        if let tripImage = tripImageView.image {
            let imageData = tripImage.jpegData(compressionQuality: 0.8)
            trip.setValue(imageData, forKey: "imageData")
        }
  
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        trip?.place = placeTextField.text
        trip?.finished = finishedDatePicker.date
        trip?.started = startedDatePicker.date
        trip?.moneySpend = moneyTextField.text
        
        if let tripImage = tripImageView.image {
            let imageData = tripImage.jpegData(compressionQuality: 0.8)
            trip?.imageData = imageData
        }
        
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
        
        // Background view
        let backgroundView = setupBackgroundView(height: 400)
        
        
        // Image View
        view.addSubview(tripImageView)
        tripImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        tripImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        // Trip Place label
        view.addSubview(placeLabel)
        placeLabel.anchor(top: tripImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
        
        // Trip Place textfield
        view.addSubview(placeTextField)
        placeTextField.anchor(top: placeLabel.topAnchor, left: placeLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        placeTextField.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor).isActive = true
        
        // Trip Money label
        view.addSubview(moneyLabel)
        moneyLabel.anchor(top: placeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
        
        // Trip Money textfield
        view.addSubview(moneyTextField)
        moneyTextField.anchor(top: moneyLabel.topAnchor, left: moneyLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        moneyTextField.centerYAnchor.constraint(equalTo: moneyLabel.centerYAnchor).isActive = true
       
        // Date Started datepicker
        view.addSubview(startedDatePicker)
        startedDatePicker.anchor(top: moneyLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        // Date Finished datepicker
        view.addSubview(finishedDatePicker)
        finishedDatePicker.anchor(top: startedDatePicker.bottomAnchor, left: view.leftAnchor, bottom: backgroundView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func setupCircularImageStyle() {
        tripImageView.layer.cornerRadius = tripImageView.frame.width / 2
        tripImageView.clipsToBounds = true
        tripImageView.layer.borderWidth = 2
        tripImageView.layer.borderColor = UIColor.darkBlue.cgColor
    }
}



