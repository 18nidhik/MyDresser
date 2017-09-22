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
    var newUser = true
    var logout:UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "My Dresser"
        if let uniqueId = UserDefaults.standard.string(forKey: "userID"){
        userUniqueId = uniqueId
            print(uniqueId)
        }
        newUser = UserDefaults.standard.bool(forKey: "newUser")
        print("new user status is \(newUser)")
        navigationItem.hidesBackButton = true
        userId = userUniqueId
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let logout = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
        self.navigationItem.setRightBarButtonItems([logout], animated: true)
        }
    
    // when logout button is pressed
    func logoutAction() {
        
        UserDefaults.standard.set(false, forKey: "loginStatus")
        //UserDefaults.standard.removeObject(forKey: "userID")
        if  let InitialVc = self.storyboard?.instantiateViewController(withIdentifier: "InitialController") {
        let InitialNavigationVC = UINavigationController(rootViewController: InitialVc)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = InitialNavigationVC
         navigationController?.popToRootViewController(animated: true)
        }

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
    
    //Label title for each row
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOrSuggestCell", for: indexPath) as? ChooseOrSuggestTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        cell.optionLabel.text = optionsToChoose[indexPath.row]
        return cell
    }
    
    // When a particular row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        let categoryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"CategoryViewController") as! CategoryViewController
        categoryVC.chooseOrSuggest = self.optionsToChoose[(indexPath?.row)!]
        categoryVC.userId = self.userId
        categoryVC.newUser = self.newUser
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
}
