//
//  ProfilePreviousTableViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 26/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class ProfilePreviousTableViewController: UITableViewController {
    var userId = ""
    var noOfCategories: [String] = ["Casual","Formal","Ethnic","Other"]
    var casualTopUrl :[String] = []
    var casualBottomUrl :[String] = []
    var casualLabel :[Int] = []
    var formalTopUrl :[String] = []
    var formalBottomUrl :[String] = []
    var formalLabel :[Int] = []
    var ethnicTopUrl :[String] = []
    var ethnicBottomUrl :[String] = []
    var ethnicLabel :[Int] = []
    var otherTopUrl :[String] = []
    var otherBottomUrl :[String] = []
    var otherLabel :[Int] = []
    var numberOfDresses = 0
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My collection"
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        startActivityIndicatorForView(spinner:self.spinner, view:self.view, style:UIActivityIndicatorViewStyle.gray, x: (tableView.bounds.midX - 30), y: (tableView.bounds.midY - 30), width: 60.0, height: 60.0)
        FirebaseReference.sharedInstance.fetchDetailsFromDatabase(userId: userId, callback: {()->() in
            
            // If there are no previously worn dresses provide an alert
            if detailsOfDresses.count == 0{
                self.stopActivityIndicatorForView(spinner:self.spinner)
                let optionMenu = UIAlertController(title: nil, message: "No previously worn dresses ", preferredStyle: .alert)
                 optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
                let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                optionMenu.addAction(cantSuggest)
                self.present(optionMenu, animated: true, completion: nil)
            }
            self.stopActivityIndicatorForView(spinner:self.spinner)
            for values in detailsOfDresses{
                if values["category"] as! String == "casual"{
                    
                    let topUrlString = values["top"] as! String
                    self.casualTopUrl.append(topUrlString)
                    let bottomUrlString = values["bottom"] as! String
                    self.casualBottomUrl.append(bottomUrlString)
                    //                let label = values["label"] as? String
                    //                 self.labelsOfDresses.append(label ?? "")
                    let label = values["numberOfTimesWorn"]
                    self.casualLabel.append(label as! Int)
                }
                if values["category"] as! String == "formal"{
                    
                    let topUrlString = values["top"] as! String
                    self.formalTopUrl.append(topUrlString)
                    let bottomUrlString = values["bottom"] as! String
                    self.formalBottomUrl.append(bottomUrlString)
                    let label = values["numberOfTimesWorn"]
                    self.formalLabel.append(label as! Int)
                }
                if values["category"] as! String == "ethnic"{
                    
                    let topUrlString = values["top"] as! String
                    self.ethnicTopUrl.append(topUrlString)
                    let bottomUrlString = values["bottom"] as! String
                    self.ethnicBottomUrl.append(bottomUrlString)
                    let label = values["numberOfTimesWorn"]
                    self.ethnicLabel.append(label as! Int)
                }
                if values["category"] as! String == "other"{
                    
                    let topUrlString = values["top"] as! String
                    self.otherTopUrl.append(topUrlString)
                    let bottomUrlString = values["bottom"] as! String
                    self.otherBottomUrl.append(bottomUrlString)
                    let label = values["numberOfTimesWorn"]
                    self.otherLabel.append(label as! Int)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return noOfCategories[section]+":"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return noOfCategories.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = casualTopUrl.count
        case 1:
            count = formalTopUrl.count
        case 2:
            count = ethnicTopUrl.count
        case 3:
            count = otherTopUrl.count
        default:
            count = 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePreviousCell", for: indexPath) as? ProfilePreviousTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        cell.layer.borderWidth = 0.25
        cell.layer.borderColor = UIColor.gray.cgColor
            //UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
        cell.activityIndicator.startAnimating()
        var arrayTop : [String] = []
        var arrayBottom : [String] = []
        var arrayLabel : [Int] = []
        
        switch indexPath.section {
        case 0:
            arrayTop = casualTopUrl
            arrayBottom = casualBottomUrl
            arrayLabel = casualLabel
        case 1:
            arrayTop = formalTopUrl
            arrayBottom = formalBottomUrl
            arrayLabel = formalLabel
        case 2:
            arrayTop = ethnicTopUrl
            arrayBottom = ethnicBottomUrl
            arrayLabel = ethnicLabel
        case 3:
            arrayTop = otherTopUrl
            arrayBottom = otherBottomUrl
            arrayLabel = otherLabel
        default:
            arrayTop = []
            arrayBottom = []
            arrayLabel = []
        }
        cell.profilePreviousTop.loadImageUsingCacheWithURLString(URLString: arrayTop[indexPath.row], onCompletion: {()->() in
            
        })
        cell.profilePreviousBottom.loadImageUsingCacheWithURLString(URLString: arrayBottom[indexPath.row], onCompletion: {()->() in
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.hidesWhenStopped = true
        })
        
        if arrayLabel[indexPath.row] == 1{
            cell.profilePreviousLabel.text = "worn once"
        }
        else{
            cell.profilePreviousLabel.text = String(arrayLabel[indexPath.row])+" times worn"
        }
//        cell.activityIndicator.stopAnimating()
//        cell.activityIndicator.hidesWhenStopped = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if casualTopUrl.count == 0 {
                return 0.0
            }
            else{
                return UITableViewAutomaticDimension
            }
        case 1:
            if formalTopUrl.count == 0 {
                return 0.0
            }
            else{
                return UITableViewAutomaticDimension
            }
        case 2:
            if ethnicTopUrl.count == 0 {
                return 0.0
            }
            else{
                return UITableViewAutomaticDimension
            }
        case 3:
            if otherTopUrl.count == 0 {
                return 0.0
            }
            else{
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }
    }
}
