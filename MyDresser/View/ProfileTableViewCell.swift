//
//  ProfileTableViewCell.swift
//  MyDresser
//
//  Created by Shrinidhi K on 25/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var contentCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentCellView.backgroundColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
        contentCellView.layer.cornerRadius = 10
        contentCellView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
