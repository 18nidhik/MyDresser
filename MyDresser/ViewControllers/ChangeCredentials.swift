//
//  ChangeCredentials.swift
//  MyDresser
//
//  Created by Shrinidhi K on 26/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit


enum CredentialType {
    
    case email
    case password
}
class ChangeCredentials: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var confirmNewCredential: UITextField!
    @IBOutlet weak var newCredential: UITextField!
    @IBOutlet weak var oldCredential: UITextField!
    var credentialType = CredentialType.email
    var gradientLayer: CAGradientLayer!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if credentialType == CredentialType.email{
            navigationItem.title = "Change EmailId"
            newCredential.becomeFirstResponder()
        }
        else{
            navigationItem.title = "Change Password"
            oldCredential.becomeFirstResponder()
        }
        self.oldCredential.delegate = self
        self.newCredential.delegate = self
        self.confirmNewCredential.delegate = self
        hideKeyboardWhenTappedAround()
        gradientLayer = CAGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer(view: self.view, gradientLayer: self.gradientLayer)
        changeButton.layer.cornerRadius = 10
        changeButton.layer.masksToBounds = true
        // If Credential to be changed is email
        if credentialType == CredentialType.email {
            oldCredential.text = UserDefaults.standard.string(forKey: "emailID")
            newCredential.placeholder = "Enter new email ID"
            newCredential.keyboardType = .emailAddress
            confirmNewCredential.placeholder = "Enter password"
            confirmNewCredential.isSecureTextEntry = true
             setImageToTextField(textField: oldCredential, image:#imageLiteral(resourceName: "emailIcon"), x:0, y: 0,width: 40, height: 40)
            setImageToTextField(textField: newCredential, image:#imageLiteral(resourceName: "emailIcon"), x:0, y: 0,width: 40, height: 40)
            setImageToTextField(textField: confirmNewCredential, image:#imageLiteral(resourceName: "passwordIcon"), x:0, y: 0,width: 40, height: 40)
        }
            // If credential to be changed is password
        else {
            oldCredential.isSecureTextEntry = true
            newCredential.isSecureTextEntry = true
            confirmNewCredential.isSecureTextEntry = true
            oldCredential.placeholder = "Enter old password"
            newCredential.placeholder = "Enter new password"
            confirmNewCredential.placeholder = "Confirm new password"
            setImageToTextField(textField: oldCredential, image:#imageLiteral(resourceName: "passwordIcon"), x:0, y: 0,width: 40, height: 40)
            setImageToTextField(textField: newCredential, image:#imageLiteral(resourceName: "passwordIcon"), x:0, y: 0,width: 40, height: 40)
            setImageToTextField(textField: confirmNewCredential, image:#imageLiteral(resourceName: "confirmPasswordIcon"), x:0, y: 0,width: 40, height: 40)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeAction(_ sender: Any) {
        performChangeAction()
   }
    func performChangeAction(){
        
        if credentialType == CredentialType.email {
            
            guard let changedEmailId = newCredential.text ,let oldPassword = confirmNewCredential.text, !changedEmailId.isEmpty, !oldPassword.isEmpty else{
                self.showAlertController(title:"Error" , message: "Enter new emailId", actionTitle: "OK")
                return
            }
            guard let oldemailId = UserDefaults.standard.string(forKey: "emailID") else{
                self.showAlertController(title:"Error" , message: "Please logout and login again", actionTitle: "OK")
                return
            }
            
            startActivityIndicatorForView(spinner:self.spinner,view:self.view, style:UIActivityIndicatorViewStyle.whiteLarge,x: (self.view.bounds.midX - 30), y: (self.view.bounds.maxY - 160), width: 60.0, height: 60.0)
            Authentication.sharedInstance.updateEmailId(email: changedEmailId, oldemail:oldemailId, password: oldPassword, callback: {(updateSuccess, message) ->() in
                self.stopActivityIndicatorForView(spinner:self.spinner)
                if updateSuccess == true{
                    
                    UserDefaults.standard.set(changedEmailId, forKey: "emailID")
                    let optionMenu = UIAlertController(title: "Trendz", message: "Email Id changed successfully", preferredStyle: .alert)
                    optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
                    let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    })
                    optionMenu.addAction(cantSuggest)
                    self.present(optionMenu, animated: true, completion: nil)
                }
                else{
                    self.showAlertController(title:"Error" , message: message, actionTitle: "OK")
                }
            })
        }
        else {
            // Check whether entered old password is valid
            if oldCredential.text == UserDefaults.standard.string(forKey: "password") {
                // If password do not match
                guard newCredential.text == confirmNewCredential.text else{
                    self.showAlertController(title:"Error" , message: "Passwords do not match.", actionTitle: "OK")
                    return
                }
                guard let oldPassword = oldCredential.text, let changedPassword = newCredential.text, let changedConfirmPassword = confirmNewCredential.text , !changedPassword.isEmpty, !changedConfirmPassword.isEmpty,!oldPassword.isEmpty else{
                    self.showAlertController(title:"Error" , message: "Enter new password.", actionTitle: "OK")
                    return
                }
                guard let oldemailId = UserDefaults.standard.string(forKey: "emailID") else{
                    self.showAlertController(title:"Error" , message: "Please logout and login again.", actionTitle: "OK")
                    return
                }
                startActivityIndicatorForView(spinner:self.spinner,view:self.view, style:UIActivityIndicatorViewStyle.whiteLarge,x: (self.view.bounds.midX - 30), y: (self.view.bounds.maxY - 160), width: 60.0, height: 60.0)
                Authentication.sharedInstance.updatePassword(password: changedPassword, oldemail:oldemailId, oldpassword: oldPassword,callback: {(updateSuccess, message) ->() in
                    self.stopActivityIndicatorForView(spinner:self.spinner)
                    if updateSuccess == true{
                        
                        UserDefaults.standard.set(changedPassword, forKey: "password")
                        let optionMenu = UIAlertController(title: "Trendz", message: "Password changed successfully.", preferredStyle: .alert)
                        optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
                        let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                            (alert: UIAlertAction!) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        })
                        optionMenu.addAction(cantSuggest)
                        self.present(optionMenu, animated: true, completion: nil)
                    }
                    else{
                        self.showAlertController(title:"Error" , message: message, actionTitle: "OK")
                    }
                })
            }
            else{
                self.showAlertController(title:"Error" , message: "Enter valid current password. ", actionTitle: "OK")
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        switch textField {
            
        case oldCredential: textField.resignFirstResponder()
        newCredential.becomeFirstResponder()
        
        case newCredential: textField.resignFirstResponder()
        confirmNewCredential.becomeFirstResponder()
        
        default: textField.resignFirstResponder()
            performChangeAction()
        }

        return true
    }
    
}
