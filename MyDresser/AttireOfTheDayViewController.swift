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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func attireSelected(_ sender: Any) {
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
