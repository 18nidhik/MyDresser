//
//  ChooseOrSuggestTableViewCell.swift
//  MyDresser
//
//  Created by Shrinidhi K on 06/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class ChooseOrSuggestTableViewCell: UITableViewCell {
      var buttonObj : (() -> Void)? = nil
    @IBAction func selectOrChooseAction(_ sender: Any) {

        if let btnAction = self.buttonObj
        {
            btnAction()
        }
    
    }
    @IBOutlet weak var optionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
