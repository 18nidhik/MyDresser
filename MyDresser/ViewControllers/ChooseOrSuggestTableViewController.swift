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
        userId = userUniqueId
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return optionsToChoose.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOrSuggestCell", for: indexPath) as? ChooseOrSuggestTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        cell.optionLabel.text = optionsToChoose[indexPath.row]
        cell.buttonObj =
            {
                let categoryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"CategoryViewController") as! CategoryViewController
                categoryVC.chooseOrSuggest = self.optionsToChoose[indexPath.row]
                categoryVC.userId = self.userId
                categoryVC.newUser = self.newUser
                self.navigationController?.pushViewController(categoryVC, animated: true)

        }
        return cell
    }
}
