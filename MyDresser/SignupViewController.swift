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

class SignupViewController: UIViewController {

    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
          ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        let enteredEmailId =  emailIdText.text
        let enteredPassword = passwordText.text
        let enteredConfirmPassword = confirmPasswordText.text
        
        guard let emailId = enteredEmailId, let password = enteredPassword, let confirmPassword = enteredConfirmPassword, !emailId.isEmpty, !password.isEmpty else {
            
            let alertController = UIAlertController(title: "Please fill all the details correctly!", message: "Try again", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        guard password == confirmPassword else{
            let alertController = UIAlertController(title: "Passwords donot match", message: "Try again", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: emailId, password: password, completion: { (user, error) in
            
            if let user = user {
                //user found
                print(user)
                let uid = user.uid
                print("userid is \(uid)")
                print("user created")
                let chooseOrSuggestTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChooseOrSuggestController") as! ChooseOrSuggestTableViewController
                chooseOrSuggestTVC.userUniqueId = uid
                self.navigationController?.pushViewController(chooseOrSuggestTVC, animated: true)
                
            }
            
            else {
                print("error")
                print(error)
            }
        })

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
