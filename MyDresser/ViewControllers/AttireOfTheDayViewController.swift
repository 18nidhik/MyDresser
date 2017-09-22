//
//  AttireOfTheDayViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class AttireOfTheDayViewController: UIViewController {

    @IBOutlet weak var bottomAttireImage: UIImageView!
    @IBOutlet weak var topAttireImage: UIImageView!
    var topImage: UIImage? = nil
    var bottomImage: UIImage? = nil
    var newUser = false
    var attireOk:UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Attire of the Day"
        let attireOk = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(attireOkAction))
        self.navigationItem.setRightBarButtonItems([attireOk], animated: true)
        topAttireImage.image = topImage
        bottomAttireImage.image = bottomImage
        }
    
    func attireOkAction(){
        if newUser == true{
            self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
        }
        else{
            print(newUser)
            // self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
