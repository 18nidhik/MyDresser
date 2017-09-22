//
//  InitialViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 14/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var buttonTop: NSLayoutConstraint!
    @IBOutlet weak var labelTop: NSLayoutConstraint!
    @IBOutlet weak var myDresserLabe: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      animate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // When login button is clicked
    @IBAction func loginAction(_ sender: Any) {
        let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"LoginController") as! LoginViewController
        self.navigationController?.pushViewController( loginVC, animated: true)
    }
    
    //When SignUp button is clicked
    @IBAction func signUpAction(_ sender: Any) {
        let signUpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"SignupController") as! SignupViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        super.viewWillDisappear(animated)
//    }
    func animate()
    {
                UIView.animate(withDuration: 2, delay: 2, options: .curveEaseIn, animations: {
                    self.buttonTop.constant = 215
                    self.labelTop.constant = 60
                    self.view.layoutIfNeeded()
                }) { (flag) in

                }
    }
}
