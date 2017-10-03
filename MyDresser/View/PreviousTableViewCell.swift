//
//  PreviousTableViewCell.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class PreviousTableViewCell: UITableViewCell {
    
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topPreviousImage: UIImageView!
    @IBOutlet weak var bottomPreviousImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.previousLabel.textColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
