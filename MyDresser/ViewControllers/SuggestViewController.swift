//
//  SuggestViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseDatabase

var  countSuggesstion = 0
class SuggestViewController: UIViewController {
    
    @IBOutlet weak var suggestedTopImage: UIImageView!
    @IBOutlet weak var suggestedBottomImage: UIImageView!
    var userId: String = ""
    var categoryOfDress:DressCategory = .other
    var topUrl: URL?
    var bottomUrl: URL?
    var indexOfSuggestedDress = -1
    var updateNumber = 0   //update number of times worn if suggested dress is selected
    var newUser = false
    var numberOfDressesInTheCategorySelected = 0
    var suggessionList:[[String:AnyObject]] = []
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        countSuggesstion = 0
        navigationItem.title = "Suggested Attire"
        detailsOfDresses = []
        keys = []
        self.startActivityIndicator()
        FirebaseReference.sharedInstance.fetchDetailsFromDatabase(userId: userId, callback: {()->() in
            print("Details fetched from database ")
            for dress in detailsOfDresses{
                if dress["category"] as! String == self.categoryOfDress.rawValue{
                    self.numberOfDressesInTheCategorySelected += 1
                    print(self.numberOfDressesInTheCategorySelected)
                }
            }
            
            if self.numberOfDressesInTheCategorySelected == 0{
                self.stopActivityIndicator()
                let optionMenu = UIAlertController(title: nil, message: "No suggestions since you have no previously selected dresses in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
                let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    if self.newUser == true{
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                    }
                    else{
                        // self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
                optionMenu.addAction(cantSuggest)
                self.present(optionMenu, animated: true, completion: nil)
            }
            else{
                // sort the array in decreasing order
                let sortedList = detailsOfDresses.sorted(by: { (lhs, rhs) -> Bool in
                    if let leftValue = lhs["numberOfTimesWorn"], let leftInt = leftValue as? Int, let rightValue = rhs["numberOfTimesWorn"], let rightInt = rightValue as? Int {
                        return leftInt > rightInt
                    } else {
                        return false                 }
                })
                for values in sortedList {
                    if values["category"] as! String == self.categoryOfDress.rawValue{
                        self.suggessionList.append(values)//
                    }
                }
                for values in self.suggessionList{
                    for (key, value) in values{
                        print("\(key) :\(value)")
                    }
                }
                let urlTopString = self.suggessionList[0]["top"] as! String
                self.topUrl = URL(string: urlTopString)!
                let urlBottomString = self.suggessionList[0]["bottom"] as! String
                self.bottomUrl = URL(string: urlBottomString)!
                self.updateNumber = self.suggessionList[0]["numberOfTimesWorn"] as! Int
                FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: self.topUrl,newImage :self.suggestedTopImage, callback:{
                    print("top image displayed")
                })
                FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: self.bottomUrl,newImage :self.suggestedBottomImage, callback:{
                    self.stopActivityIndicator()
                    print("bottom pic displayed")
                })
                for(index,values) in detailsOfDresses.enumerated(){
                    if values["category"] as! String == self.categoryOfDress.rawValue{
                        if values["top"] as! String == self.topUrl?.absoluteString && values["bottom"] as! String == self.bottomUrl?.absoluteString{
                            self.indexOfSuggestedDress = index
                            print("index is \(self.indexOfSuggestedDress)")
                        }
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startActivityIndicator(){
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
        spinner.frame = CGRect(x: (self.suggestedTopImage.frame.origin.x + (self.suggestedTopImage.frame.width/2) - 60), y: (self.suggestedTopImage.frame.origin.y + self.suggestedTopImage.frame.height), width: 60.0, height: 60.0)
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    //stopSpinner
    func stopActivityIndicator(){
        spinner.stopAnimating()
    }
    
    @IBAction func suggestedDressOk(_ sender: Any) {
        print("update now")
        updateNumber += 1
        FirebaseReference.sharedInstance.updateDatabase(userId: self.userId, key: keys[indexOfSuggestedDress] as! String,updateNumber: self.updateNumber, callback: {()->() in
            if self.newUser == true{
                self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
            }
            else{
                // self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    @IBAction func suggestedDressReject(_ sender: Any) {
        if self.newUser == true{
            self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
        }
        else{
            //self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func suggestMeSomethingElse(_ sender: Any) {
        countSuggesstion += 1
        if countSuggesstion < suggessionList.count{
            let urlTopString = self.suggessionList[countSuggesstion]["top"] as! String
            self.topUrl = URL(string: urlTopString)!
            let urlBottomString = self.suggessionList[countSuggesstion]["bottom"] as! String
            self.bottomUrl = URL(string: urlBottomString)!
            self.updateNumber = self.suggessionList[countSuggesstion]["numberOfTimesWorn"] as! Int
            FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: self.topUrl,newImage :self.suggestedTopImage, callback:{
                print("top image displayed")
            })
            FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: self.bottomUrl,newImage :self.suggestedBottomImage, callback:{
                print("bottom pic displayed")
            })
            for(index,values) in detailsOfDresses.enumerated(){
                if values["category"] as! String == self.categoryOfDress.rawValue{
                    if values["top"] as! String == self.topUrl?.absoluteString && values["bottom"] as! String == self.bottomUrl?.absoluteString{
                        self.indexOfSuggestedDress = index
                        print("index is \(self.indexOfSuggestedDress)")
                    }
                }
            }
        }
        else{
            let optionMenu = UIAlertController(title: nil, message: "No more dresses to suggest in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
            let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                if self.newUser == true{
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                }
                else{
                    //self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
            optionMenu.addAction(cantSuggest)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
}
