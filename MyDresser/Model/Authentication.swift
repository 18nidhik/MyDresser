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
    
    static let sharedInstance = Authentication()
    func userLogin(emailId: String, password: String, callback: @escaping (_ loginSuccess: Bool, _ uid: String)->()){
        var loginSuccess: Bool = false
        var uid = ""
        Auth.auth().signIn(withEmail: emailId, password: password, completion: { (user, error) in
            if let user = user {
                print(user)
                uid = user.uid
                print("userid is \(uid)")
                loginSuccess = true
            } else {
              loginSuccess = false
            }
            callback(loginSuccess, uid)
        })
        
    }
    func createUser(emailId: String, password: String, callback: @escaping (_ signupSuccess: Bool, _ uid: String)->()){
        var signupSuccess: Bool = false
        var uid = ""
        Auth.auth().createUser(withEmail: emailId, password: password, completion: { (user, error) in
            
            if let user = user {
                //user found
                print(user)
                uid = user.uid
                print("userid is \(uid)")
                print("user created")
                signupSuccess = true
            }
                
            else {
                print("error")
                print(error ?? "error")
                signupSuccess = false
            }
            callback(signupSuccess, uid)
        })

    }
}
