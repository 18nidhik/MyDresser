//
//  ProfilePreviousTableViewCell.swift
//  MyDresser
//
//  Created by Shrinidhi K on 26/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class ProfilePreviousTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePreviousLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profilePreviousBottom: UIImageView!
    @IBOutlet weak var profilePreviousTop: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
         self.profilePreviousLabel.textColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
