//
//  PreviousTableViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class PreviousTableViewController: UITableViewController {
    
    var categoryOfDress: DressCategory = .other
    var userId: String = ""
    var urlsOfTop :[URL] = []
    var urlsOfBottom :[URL] = []
    var labelsOfDresses :[String] = []
    var newUser = false
    var numberOfDressesInTheCategorySelected = 0
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "My collection"
        startActivityIndicatorForView(spinner:self.spinner, view:self.view, style:UIActivityIndicatorViewStyle.gray, x: (tableView.bounds.midX - 30), y: (tableView.bounds.midY - 30), width: 60.0, height: 60.0)
        
        // Fetch details from firebase and check if there are previously worn dresses in the selected category
        FirebaseReference.sharedInstance.fetchDetailsFromDatabase(userId: userId, callback: {()->() in
            for dress in detailsOfDresses{
                if dress["category"] as! String == self.categoryOfDress.rawValue{
                    self.numberOfDressesInTheCategorySelected += 1
                    print(self.numberOfDressesInTheCategorySelected)
                }
            }
            
            // If there are no previously worn dresses in the selected category, provide an alert
            if self.numberOfDressesInTheCategorySelected == 0{
                self.stopActivityIndicatorForView(spinner:self.spinner)
                let optionMenu = UIAlertController(title: nil, message: "No previously selected dresses in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
                optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
                let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                optionMenu.addAction(cantSuggest)
                self.present(optionMenu, animated: true, completion: nil)
            }
            
            self.stopActivityIndicatorForView(spinner:self.spinner)
            // get the URLs of top and bottom attire and the label of dress to display on the table view
            for values in detailsOfDresses{
                if values["category"] as! String == self.categoryOfDress.rawValue{
                    let topUrlString = values["top"] as! String
                    let topUrl = URL(string: topUrlString)
                    self.urlsOfTop.append(topUrl!)
                    let bottomUrlString = values["bottom"] as! String
                    let bottomUrl = URL(string: bottomUrlString)
                    self.urlsOfBottom.append(bottomUrl!)
                    //                    let label = values["label"] as? String
                    //                    self.labelsOfDresses.append(label ?? "")
                    let label = values["label"]
                    self.labelsOfDresses.append(label as! String)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlsOfTop.count
    }
    
    // Display top and bottom attire image of previously worn dresses in each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousCell", for: indexPath) as? PreviousTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        cell.layer.borderWidth = 0.25
        cell.layer.borderColor = UIColor.gray.cgColor
            //UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
        cell.activityIndicator.startAnimating()
        // Display top image
        cell.topPreviousImage.loadImageUsingCacheWithURLString(URLString: urlsOfTop[indexPath.row].absoluteString, onCompletion: {()->() in
        })
        //Display bottom image
        cell.bottomPreviousImage.loadImageUsingCacheWithURLString(URLString: urlsOfBottom[indexPath.row].absoluteString, onCompletion: {()->() in
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.hidesWhenStopped = true
        })
        // Display label of dress
        cell.previousLabel.text = self.labelsOfDresses[indexPath.row]
//        cell.activityIndicator.stopAnimating()
//        cell.activityIndicator.hidesWhenStopped = true
        return cell
    }
    
    // When a previously worn dress is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        let newDressVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"NewDressController") as! NewDressViewController
        newDressVC.categoryOfPreviousDress  = categoryOfDress
        newDressVC.topUrlOfPreviousDress = urlsOfTop[(indexPath?.row)!]
        newDressVC.bottomUrlOfPreviousDress = urlsOfBottom[(indexPath?.row)!]
        newDressVC.labelOfPreviousDress = labelsOfDresses[(indexPath?.row)!]
        newDressVC.userId = self.userId
        newDressVC.newUser = self.newUser
        self.navigationController?.pushViewController(newDressVC, animated: true)
    }
}
