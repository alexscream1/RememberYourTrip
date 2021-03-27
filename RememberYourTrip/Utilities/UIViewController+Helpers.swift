//
//  UIViewController+Helpers.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 26.03.2021.
//

import UIKit



extension UIViewController {
    
    // MARK: - Setup NavigationBar Style
    
    func setupNavBarStyle() {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .lightRed
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Setup plus button in NavigationBar
    
    func setupPlusButton(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    // MARK: - Setup cancel button in NavigationBar
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
    }
    
    @objc private func cancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup save button in NavigationBar
    
    func setupSaveButton(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
    }
    
    
    // MARK: - Setup lightblue background view
    
    func setupBackgroundView(height: CGFloat) -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightBlue
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: height)
        
        return backgroundView
    }
    
    
    // MARK: - Setup error alert controller
    
    func showError(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
