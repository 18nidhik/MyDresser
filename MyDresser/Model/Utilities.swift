//
//  Utilities.swift
//  MyDresser
//
//  Created by Shrinidhi K on 13/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // function to show alert controller
    func showAlertController(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Hide the keyboard when tapped on the view
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
