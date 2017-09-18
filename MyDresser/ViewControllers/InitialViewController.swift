//
//  InitialViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 14/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"LoginController") as! LoginViewController
        self.navigationController?.pushViewController( loginVC, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let signUpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"SignupController") as! SignupViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
}
