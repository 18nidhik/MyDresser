//
//  PreviousOrNewTableViewCell.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class PreviousOrNewTableViewCell: UITableViewCell {

    @IBOutlet weak var previousOrNewLabel: UILabel!
    var buttonObj : (() -> Void)? = nil
    
    @IBAction func previousOrNewSelect(_ sender: Any) {
        
        if let btnAction = self.buttonObj
        {
            btnAction()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
