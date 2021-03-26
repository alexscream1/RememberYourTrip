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
    
    private func setupCircularImageStyle() {
        tripImageView.layer.cornerRadius = tripImageView.frame.width / 2
        tripImageView.clipsToBounds = true
        tripImageView.layer.borderWidth = 2
        tripImageView.layer.borderColor = UIColor.darkBlue.cgColor
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
    
    let moneyLabel : UILabel = {
        let label = UILabel()
        label.text = "Money"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moneyTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter money that you spend $"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let startedDatePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        //dp.preferredDatePickerStyle = .wheels
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    let finishedDatePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        //dp.preferredDatePickerStyle = .wheels
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    lazy var tripImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return iv
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
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
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
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
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
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightBlue
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        // Image View
        view.addSubview(tripImageView)
        tripImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        tripImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        tripImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        tripImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        

        // Trip Place label
        view.addSubview(placeLabel)
        placeLabel.topAnchor.constraint(equalTo: tripImageView.bottomAnchor).isActive = true
        placeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        placeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Trip Place textfield
        view.addSubview(placeTextField)

        placeTextField.leftAnchor.constraint(equalTo: placeLabel.rightAnchor).isActive = true
        placeTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        placeTextField.topAnchor.constraint(equalTo: placeLabel.topAnchor).isActive = true
        placeTextField.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor).isActive = true
      
        // Trip Money label
        view.addSubview(moneyLabel)
        moneyLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor).isActive = true
        moneyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        moneyLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        moneyLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Trip Money textfield
        view.addSubview(moneyTextField)
        moneyTextField.leftAnchor.constraint(equalTo: moneyLabel.rightAnchor).isActive = true
        moneyTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        moneyTextField.topAnchor.constraint(equalTo: moneyLabel.topAnchor).isActive = true
        moneyTextField.centerYAnchor.constraint(equalTo: moneyLabel.centerYAnchor).isActive = true
        
        // Date Started datepicker
        
        view.addSubview(startedDatePicker)
        startedDatePicker.topAnchor.constraint(equalTo: moneyLabel.bottomAnchor).isActive = true
        startedDatePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        startedDatePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        startedDatePicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Date Finished datepicker
        
        view.addSubview(finishedDatePicker)
        finishedDatePicker.topAnchor.constraint(equalTo: startedDatePicker.bottomAnchor).isActive = true
        finishedDatePicker.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        finishedDatePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        finishedDatePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateTripController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            tripImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            tripImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
