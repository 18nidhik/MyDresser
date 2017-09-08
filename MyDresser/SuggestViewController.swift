//
//  SuggestViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class SuggestViewController: UIViewController {

    @IBOutlet weak var suggestedTopImage: UIImageView!
    @IBOutlet weak var suggestedBottomImage: UIImageView!
    var categoryOfDress:DressCategory = .other
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func suggestedDressOk(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
   
    @IBAction func suggestedDressReject(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
