//
//  Authentication.swift
//  MyDresser
//
//  Created by Shrinidhi K on 14/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class Authentication{
    
    let firebaseAuth =  Auth.auth()
    static let sharedInstance = Authentication()
    
    // user login function
    func userLogin(emailId: String, password: String, callback: @escaping (_ loginSuccess: Bool, _ uid: String)->()){
        var loginSuccess: Bool = false
        var uid = ""
        firebaseAuth.signIn(withEmail: emailId, password: password, completion: { (user, error) in
            if let user = user {
                print(user)
                uid = user.uid
                print("userid is \(uid)")
                loginSuccess = true
            }
            else {
                loginSuccess = false
            }
            callback(loginSuccess, uid)
        })
    }
    
    // SignUp function
    func createUser(emailId: String, password: String, callback: @escaping (_ signupSuccess: Bool, _ uid: String)->()){
        var signupSuccess: Bool = false
        var uid = ""
        firebaseAuth.createUser(withEmail: emailId, password: password, completion: { (user, error) in
            if let user = user {
                print(user)
                uid = user.uid
                print("userid is \(uid)")
                print("user created")
                signupSuccess = true
            }
            else {
                print("error")
                print(error ?? "error")
                uid = (error?.localizedDescription)!
                signupSuccess = false
            }
            callback(signupSuccess, uid)
        })
    }
    
    func updateEmailId(email: String,oldemail:String,password:String, callback:@escaping (_ updateSuccess: Bool, _ message:String)->()){
        var updateSuccess = false
        var message = ""
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: oldemail, password: password)
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                updateSuccess = false
                print(error.localizedDescription)
                message = error.localizedDescription
                callback(updateSuccess, message)
            } else {
                user?.updateEmail(to: email) { (error) in
                    if let error = error{
                        updateSuccess = false
                        print(error.localizedDescription)
                        message = error.localizedDescription
                    }
                    else{
                        updateSuccess = true
                        print(email)
                        print("email changed successfully")
                        message = "emailId changed successfully"
                    }
                    callback(updateSuccess, message)
                }
            }
            // callback(updateSuccess, message)
        }
    }
    
    func updatePassword(password: String, oldemail:String, oldpassword:String, callback:@escaping (_ updateSuccess: Bool, _ message:String)->()){
        var updateSuccess = false
        var message = ""
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: oldemail, password: oldpassword)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                updateSuccess = false
                print(error.localizedDescription)
                message = error.localizedDescription
                callback(updateSuccess, message)
            }
            else{
                user?.updatePassword(to: password) { (error) in
                    if let error = error{
                        updateSuccess = false
                        print(error.localizedDescription)
                        message = error.localizedDescription
                    }
                    else{
                        updateSuccess = true
                        print(password)
                        print("password changed successfully")
                        message = "passsword changed successfully"
                    }
                    callback(updateSuccess, message)
                }
            }
            
        }
    }
}
