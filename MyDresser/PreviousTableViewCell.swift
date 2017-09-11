//
//  PreviousTableViewCell.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class PreviousTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topPreviousImage: UIImageView!
    @IBOutlet weak var bottomPreviousImage: UIImageView!
//    var buttonObj : (() -> Void)? = nil
//    @IBAction func previousDressSelected(_ sender: Any) {
//        if let btnAction = self.buttonObj
//        {
//            btnAction()
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
