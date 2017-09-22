//
//  PreviousOrNewTableViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class PreviousOrNewTableViewController: UITableViewController {
    
    var categoryOfDress:DressCategory = .other
    var optionsToChoose = ["Previously worn dresses","New dress"]
    var userId: String = ""
    var newUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose your preference"
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsToChoose.count
    }
    
    // Title for each row in table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousOrNewCell", for: indexPath) as? PreviousOrNewTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        cell.previousOrNewLabel.text = optionsToChoose[indexPath.row]
        return cell
    }
    
    // When a particular row is selcted
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        if indexPath?.row == 0{
            let previousVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"PreviousController") as! PreviousTableViewController
            previousVC.categoryOfDress = self.categoryOfDress
            previousVC.userId = self.userId
            previousVC.newUser = self.newUser
            self.navigationController?.pushViewController(previousVC, animated: true)
        }
        else if indexPath?.row == 1{
            let newDressVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"NewDressController") as! NewDressViewController
            newDressVC.categoryOfDress = self.categoryOfDress
            newDressVC.userId = self.userId
            newDressVC.newUser = self.newUser
            self.navigationController?.pushViewController(newDressVC, animated: true)
        }
    }
}
