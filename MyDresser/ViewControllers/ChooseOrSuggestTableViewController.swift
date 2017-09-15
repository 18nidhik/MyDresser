//
//  ChooseOrSuggestTableViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 06/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class ChooseOrSuggestTableViewController: UITableViewController {
    
    var optionsToChoose = ["Choose my Attire","Suggest Me Something"]
    var userUniqueId: String = ""
    var userId :String = ""
    var newUser = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Choose or Suggest me something"
        navigationItem.hidesBackButton = true
        userId = userUniqueId
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsToChoose.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOrSuggestCell", for: indexPath) as? ChooseOrSuggestTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        cell.optionLabel.text = optionsToChoose[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        let categoryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"CategoryViewController") as! CategoryViewController
        categoryVC.chooseOrSuggest = self.optionsToChoose[(indexPath?.row)!]
        categoryVC.userId = self.userId
        categoryVC.newUser = self.newUser
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
}
