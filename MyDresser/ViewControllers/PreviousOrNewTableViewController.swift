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
        navigationItem.title = "My preference"
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "barImage") , for: .default)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        
        super.willMove(toParentViewController: parent)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "whiteDownload") , for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsToChoose.count
    }
    
    // Title for each row in table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousOrNewCell", for: indexPath) as? PreviousOrNewTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        // Set border for cell
        let borderViewHeight: CGFloat = 0.25
        let borderViews =  UIView(frame: CGRect(x: 0, y: cell.frame.height - borderViewHeight, width: cell.frame.width, height: borderViewHeight))
        borderViews.backgroundColor = UIColor.gray
        cell.addSubview(borderViews)
//        cell.layer.borderWidth = 0.25
//        cell.layer.borderColor = UIColor.gray.cgColor
            //UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
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
