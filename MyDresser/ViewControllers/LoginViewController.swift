//
//  LoginViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 11/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login Page"
        self.emailIdText.delegate = self
        self.passwordText.delegate = self
        ref = Database.database().reference()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.cxzczx
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        performLoginAction()
        
        }

    @IBAction func signUpAction(_ sender: Any) {
        let signUpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"SignupController") as! SignupViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    func performLoginAction()
    {
        let enteredEmailId =  self.emailIdText.text
        let enteredPassword = self.passwordText.text
        
        guard let emailId = enteredEmailId, let password = enteredPassword, !emailId.isEmpty, !password.isEmpty else {
            showAlertController(title:"Try Again" , message: "Please fill all the details correctly", actionTitle: "OK")
            return
        }
        Auth.auth().signIn(withEmail: emailId, password: password, completion: { (user, error) in
            if let user = user {
                print(user)
                let uid = user.uid
                print("userid is \(uid)")
                let chooseOrSuggestTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChooseOrSuggestController") as! ChooseOrSuggestTableViewController
                chooseOrSuggestTVC.userUniqueId = uid
                chooseOrSuggestTVC.newUser = false
                self.navigationController?.pushViewController(chooseOrSuggestTVC, animated: true)
                
            } else {
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
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
