//
//  SignupViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 11/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sign up to MyDresser"
        emailIdText.delegate = self
        passwordText.delegate = self
        confirmPasswordText.delegate = self
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    @IBAction func signUpAction(_ sender: Any) {
        performSignUpAction()
    }
    
    func performSignUpAction(){
        let enteredEmailId =  emailIdText.text
        let enteredPassword = passwordText.text
        let enteredConfirmPassword = confirmPasswordText.text
        
        guard let emailId = enteredEmailId, let password = enteredPassword, let confirmPassword = enteredConfirmPassword, !emailId.isEmpty, !password.isEmpty else {
            showAlertController(title:"Try Again" , message: "Please fill all the details correctly", actionTitle: "OK")
            return
        }
        guard password == confirmPassword else{
            showAlertController(title:"Try Again" , message: "Passwords do not match", actionTitle: "OK")
            return
        }
        startActivityIndicator()
        Authentication.sharedInstance.createUser(emailId: emailId, password: password, callback: {(_ signupSuccess: Bool, _ uid: String)->() in
            self.stopActivityIndicator()
            if signupSuccess == true{
                let chooseOrSuggestTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChooseOrSuggestController") as! ChooseOrSuggestTableViewController
                chooseOrSuggestTVC.userUniqueId = uid
                chooseOrSuggestTVC.newUser = true
                self.navigationController?.pushViewController(chooseOrSuggestTVC, animated: true)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.confirmPasswordText.isFirstResponder {
            self.confirmPasswordText.resignFirstResponder()
            performSignUpAction()
        } else if self.emailIdText.isFirstResponder {
            self.emailIdText.resignFirstResponder()
            self.passwordText.becomeFirstResponder()
        } else{
            self.passwordText.resignFirstResponder()
            self.confirmPasswordText.becomeFirstResponder()
        }
        return true
    }
    func startActivityIndicator(){
        
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
        spinner.frame = CGRect(x: (self.view.bounds.midX - 30), y: (self.view.bounds.maxY - 30), width: 60.0, height: 60.0)
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    //stopSpinner
    func stopActivityIndicator(){
        spinner.stopAnimating()
    }

}
