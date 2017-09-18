//
//  LoginViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 11/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Login to MyDresser"
        self.emailIdText.delegate = self
        self.passwordText.delegate = self
        hideKeyboardWhenTappedAround()
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    @IBAction func loginAction(_ sender: Any) {
        performLoginAction()
        }

    func performLoginAction(){
        
        let enteredEmailId =  self.emailIdText.text
        let enteredPassword = self.passwordText.text
        guard let emailId = enteredEmailId, let password = enteredPassword, !emailId.isEmpty, !password.isEmpty else {
            showAlertController(title:"Try Again" , message: "Please fill all the details correctly", actionTitle: "OK")
            return
        }
        startActivityIndicator()
        Authentication.sharedInstance.userLogin(emailId: emailId, password: password, callback: {(loginSuccess, uid) ->() in
            self.stopActivityIndicator()
            if loginSuccess == true{
                UserDefaults.standard.set(uid, forKey: "userID")
                UserDefaults.standard.set(true, forKey: "loginStatus")
                UserDefaults.standard.set(true, forKey: "newUser")
                let login = UserDefaults.standard.bool(forKey: "loginStatus")
                print("user defaults value of login status is \(login)")
                let chooseOrSuggestTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChooseOrSuggestController") as! ChooseOrSuggestTableViewController
               // chooseOrSuggestTVC.userUniqueId = uid
                chooseOrSuggestTVC.newUser = false
                self.navigationController?.pushViewController(chooseOrSuggestTVC, animated: true)
            }
            else{
                 self.showAlertController(title:"Could not log in" , message: "Check entered details", actionTitle: "OK")
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.passwordText.isFirstResponder {
            self.passwordText.resignFirstResponder()
            performLoginAction()
            
            } else {
            
            self.emailIdText.resignFirstResponder()
            self.passwordText.becomeFirstResponder()
            }
            return true
    }
    
    //Start activity indicator
    func startActivityIndicator(){
        
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.whiteLarge
        spinner.frame = CGRect(x: (self.view.bounds.midX - 30), y: (self.view.bounds.maxY - 100), width: 60.0, height: 60.0)
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    //stopSpinner
    func stopActivityIndicator(){
        spinner.stopAnimating()
    }
}

