//
//  AttireOfTheDayViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class AttireOfTheDayViewController: UIViewController {
    
    @IBOutlet weak var attireOkButton: UIButton!
    
    @IBOutlet weak var bottomAttireImage: UIImageView!
    @IBOutlet weak var topAttireImage: UIImageView!
    var topImage: UIImage? = nil
    var bottomImage: UIImage? = nil
    var newUser = false
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "My attire"
        topAttireImage.image = topImage
        bottomAttireImage.image = bottomImage
        attireOkButton.layer.cornerRadius = 10
        attireOkButton.layer.masksToBounds = true
        gradientLayer = CAGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        createGradientLayerForButton(view:attireOkButton, gradientLayer: self.gradientLayer)
    }
    
    @IBAction func attireOkAction(_ sender: Any) {
        
        if newUser == true{
            self.navigationController?.popToRootViewController(animated: true)
            //    self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
        }
        else{
            print(newUser)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
