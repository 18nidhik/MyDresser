//
//  SignupViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 11/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sign up to MyDresser"
        emailIdText.delegate = self
        passwordText.delegate = self
        confirmPasswordText.delegate = self
        ref = Database.database().reference()
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        Authentication.sharedInstance.createUser(emailId: emailId, password: password, callback: {(_ signupSuccess: Bool, _ uid: String)->() in
            if signupSuccess == true{
                let chooseOrSuggestTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChooseOrSuggestController") as! ChooseOrSuggestTableViewController
                chooseOrSuggestTVC.userUniqueId = uid
                chooseOrSuggestTVC.newUser = true
                self.navigationController?.pushViewController(chooseOrSuggestTVC, animated: true)

            }
        })
//        Auth.auth().createUser(withEmail: emailId, password: password, completion: { (user, error) in
//            
//            if let user = user {
//                //user found
//                print(user)
//                let uid = user.uid
//                print("userid is \(uid)")
//                print("user created")
//                let chooseOrSuggestTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChooseOrSuggestController") as! ChooseOrSuggestTableViewController
//                chooseOrSuggestTVC.userUniqueId = uid
//                chooseOrSuggestTVC.newUser = true
//                self.navigationController?.pushViewController(chooseOrSuggestTVC, animated: true)
//                
//            }
//                
//            else {
//                print("error")
//                print(error)
//            }
//        })

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
}
