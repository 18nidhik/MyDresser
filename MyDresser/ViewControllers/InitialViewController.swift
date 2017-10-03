//
//  InitialViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 14/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    @IBOutlet weak var buttonTop: NSLayoutConstraint!
    @IBOutlet weak var labelTop: NSLayoutConstraint!
    @IBOutlet weak var myDresserLabe: UILabel!
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animate()
        gradientLayer = CAGradientLayer()
        
        // Corner radius for signup buttun
        signupButton.layer.cornerRadius = 8
        signupButton.layer.masksToBounds = true
        // Corner radius for login button
        loginButton.layer.cornerRadius = 8
        loginButton.layer.masksToBounds =   true
        
        // Set colour to the navigation title
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)]
        // Set colour to the back button in navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
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
        
        super.viewWillAppear(animated)
        // Hide thye navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        createGradientLayer(view: self.view, gradientLayer: self.gradientLayer)
    }
    
    // Function to animate the image and buttons
    func animate(){
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.imageView.image = #imageLiteral(resourceName: "trendzWhiteIcon")
            self.buttonTop.constant = 280
            self.imageTop.constant = 60
            self.view.layoutIfNeeded()
        }) { (flag) in
        }
    }
}
