//
//  ChooseOrSuggestTableViewCell.swift
//  MyDresser
//
//  Created by Shrinidhi K on 06/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class ChooseOrSuggestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.optionLabel.textColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
