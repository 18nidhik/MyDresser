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
    var newUser = false
    var numberOfDressesInTheCategorySelected = 0
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Previously worn"
        startActivityIndicator()
        FirebaseReference.sharedInstance.fetchDetailsFromDatabase(userId: userId, callback: {()->() in
            for dress in detailsOfDresses{
                if dress["category"] as! String == self.categoryOfDress.rawValue{
                    self.numberOfDressesInTheCategorySelected += 1
                    print(self.numberOfDressesInTheCategorySelected)
                }
            }
            if self.numberOfDressesInTheCategorySelected == 0{
                self.stopActivityIndicator()
                let optionMenu = UIAlertController(title: nil, message: "No previously selected dresses in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
                
                let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                optionMenu.addAction(cantSuggest)
                self.present(optionMenu, animated: true, completion: nil)
            }
            
            for values in detailsOfDresses{
                if values["category"] as! String == self.categoryOfDress.rawValue{
                    let topUrlString = values["top"] as! String
                    let topUrl = URL(string: topUrlString)
                    self.urlsOfTop.append(topUrl!)
                    let bottomUrlString = values["bottom"] as! String
                    let bottomUrl = URL(string: bottomUrlString)
                    self.urlsOfBottom.append(bottomUrl!)
                }
            }
            self.tableView.reloadData()
        })
}
    //start spinner
    func startActivityIndicator(){
    spinner.hidesWhenStopped = true
    spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
    spinner.frame = CGRect(x: (tableView.bounds.midX - 30), y: (tableView.bounds.midY - 30), width: 60.0, height: 60.0)
    view.addSubview(spinner)
    spinner.startAnimating()
    }
    
    //stopSpinner
    func stopActivityIndicator(){
        spinner.stopAnimating()
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

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousCell", for: indexPath) as? PreviousTableViewCell else{
            
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        
        FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: urlsOfTop[indexPath.row],newImage: cell.topPreviousImage, callback: {() ->() in
            print("top image")
        })

        FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: urlsOfBottom[indexPath.row],newImage: cell.bottomPreviousImage, callback: {() ->() in
            print("botom image")
        })
        stopActivityIndicator()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow;
       // print(indexPath?.row)
        let newDressVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"NewDressController") as! NewDressViewController
        newDressVC.categoryOfPreviousDress  = categoryOfDress
        newDressVC.topUrlOfPreviousDress = urlsOfTop[(indexPath?.row)!]
        newDressVC.bottomUrlOfPreviousDress = urlsOfBottom[(indexPath?.row)!]
        newDressVC.userId = self.userId
        newDressVC.newUser = self.newUser
        self.navigationController?.pushViewController(newDressVC, animated: true)
    }
}
