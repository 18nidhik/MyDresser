//
//  LoginViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 11/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var gradientLayer: CAGradientLayer!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Login"
        self.emailIdText.delegate = self
        self.passwordText.delegate = self
        
        // Set the keyboard type for email text field as email
        emailIdText.becomeFirstResponder()
        emailIdText.keyboardType = .emailAddress
        hideKeyboardWhenTappedAround()
        
        // Set the corner radius for login button
        loginButton.layer.cornerRadius = 8
        loginButton.layer.masksToBounds = true
        
        // Set image to the left view of text field
        setImageToTextField(textField: emailIdText, image:#imageLiteral(resourceName: "emailIcon"), x:0, y: 0,width: 40, height: 40)
        setImageToTextField(textField: passwordText, image:#imageLiteral(resourceName: "passwordIcon"), x:0, y: 0,width: 40, height: 40)
        gradientLayer = CAGradientLayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Make navigation bar visible
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        createGradientLayer(view: self.view, gradientLayer: self.gradientLayer)
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        performLoginAction()
    }
    
    func performLoginAction(){
        
        let enteredEmailId =  self.emailIdText.text
        let enteredPassword = self.passwordText.text
        
        // Show alert if any of the text fields are empty
        guard let emailId = enteredEmailId, let password = enteredPassword, !emailId.isEmpty, !password.isEmpty else {
            showAlertController(title:"Error" , message: "Please fill all the details correctly", actionTitle: "OK")
            return
        }
        startActivityIndicatorForView(spinner:self.spinner,view:self.view, style:UIActivityIndicatorViewStyle.whiteLarge,x: (self.view.bounds.midX - 30), y: (self.view.bounds.maxY - 160), width: 60.0, height: 60.0)
        
        // Authenticate the user
        Authentication.sharedInstance.userLogin(emailId: emailId, password: password, callback: {(loginSuccess, uid) ->() in
            self.stopActivityIndicatorForView(spinner:self.spinner)
            if loginSuccess == true{
                UserDefaults.standard.set(uid, forKey: "userID")
                UserDefaults.standard.set(emailId, forKey: "emailID")
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.set(true, forKey: "loginStatus")
                UserDefaults.standard.set(true, forKey: "newUser")
                let login = UserDefaults.standard.bool(forKey: "loginStatus")
                print("user defaults value of login status is \(login)")
                let tabBarVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"TabBarController") as! TabBarViewController
                let appDelegate =  UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarVC
            }
            else{
                self.showAlertController(title:"Error" , message: "Could not login. Please enter valid credentials.", actionTitle: "OK")
            }
        })
    }
    
    // Dismiss the keyboard on tapping return
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
}


