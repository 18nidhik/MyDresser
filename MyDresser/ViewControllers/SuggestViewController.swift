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
class SuggestViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //class SuggestViewController: UIViewController{
    @IBOutlet weak var collectionView: UICollectionView!
  //  @IBOutlet weak var suggestedTopImage: UIImageView!
  //  @IBOutlet weak var suggestedBottomImage: UIImageView!
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
    var suggestionOk:UIBarButtonItem = UIBarButtonItem()
        var urlsOfTop :[URL] = []
        var urlsOfBottom :[URL] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.delegate =  self
       collectionView.dataSource = self
        
        countSuggesstion = 0
        navigationItem.title = "Suggested Attire"
        detailsOfDresses = []
        keys = []
        self.startActivityIndicator()
        collectionView.register(UINib(nibName: String(describing: SuggestCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SuggestCollectionViewCell.self))

        let suggestionOk = UIBarButtonItem.init(title: "Choose", style: .plain, target: self, action: #selector(suggestionOkAction))
        self.navigationItem.setRightBarButtonItems([suggestionOk], animated: true)
        FirebaseReference.sharedInstance.fetchDetailsFromDatabase(userId: userId, callback: {()->() in
            print("Details fetched from database ")
            for dress in detailsOfDresses{
                if dress["category"] as! String == self.categoryOfDress.rawValue{
                    self.numberOfDressesInTheCategorySelected += 1
                    print(self.numberOfDressesInTheCategorySelected)
                }
            }
            
            // If there are no previously worn dresses in the selected category, provide an alert
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
                self.stopActivityIndicator()
                // sort the array in decreasing order
                let sortedList = detailsOfDresses.sorted(by: { (lhs, rhs) -> Bool in
                    if let leftValue = lhs["numberOfTimesWorn"], let leftInt = leftValue as? Int, let rightValue = rhs["numberOfTimesWorn"], let rightInt = rightValue as? Int {
                        return leftInt > rightInt
                    } else {
                        return false
                        
                    }
                })
                for values in sortedList {
                    if values["category"] as! String == self.categoryOfDress.rawValue{
                        self.suggessionList.append(values)//
                    }
                }
                for values in self.suggessionList{
                    if values["category"] as! String == self.categoryOfDress.rawValue{
                        let topUrlString = values["top"] as! String
                        let topUrl = URL(string: topUrlString)
                        self.urlsOfTop.append(topUrl!)
                        let bottomUrlString = values["bottom"] as! String
                        let bottomUrl = URL(string: bottomUrlString)
                        self.urlsOfBottom.append(bottomUrl!)
                    }
                }
               // self.tableView.reloadData()
                for values in self.suggessionList{
                    for (key, value) in values{
                        print("\(key) :\(value)")
                    }
                }
                //Suggest the first attire
                let urlTopString = self.suggessionList[0]["top"] as! String
                self.topUrl = URL(string: urlTopString)!
                let urlBottomString = self.suggessionList[0]["bottom"] as! String
                self.bottomUrl = URL(string: urlBottomString)!
                self.updateNumber = self.suggessionList[0]["numberOfTimesWorn"] as! Int
                // get the index of the suggested attire for updating
                for(index,values) in detailsOfDresses.enumerated(){
                    if values["category"] as! String == self.categoryOfDress.rawValue{
                        if values["top"] as! String == self.topUrl?.absoluteString && values["bottom"] as! String == self.bottomUrl?.absoluteString{
                            self.indexOfSuggestedDress = index
                            print("index is \(self.indexOfSuggestedDress)")
                        }
                    }
                }
            }
             self.collectionView.reloadData()
        })
        
    }
    func suggestionOkAction(){
        //Update the number of times the suggested dress is worn when clicked OK
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Start Spinner
    func startActivityIndicator(){
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.whiteLarge
        spinner.frame = CGRect(x: (collectionView.frame.width/2)-30, y: collectionView.frame.midY-30, width: 60, height: 60)
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    //stopSpinner
    func stopActivityIndicator(){
        spinner.stopAnimating()
    }
    
    @IBAction func suggestMeSomethingElse(_ sender: Any) {
        countSuggesstion += 1
        if countSuggesstion < suggessionList.count{
         let indexPath = NSIndexPath(row: countSuggesstion, section: 0)
            collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
       let urlTopString = self.suggessionList[countSuggesstion]["top"] as! String
            self.topUrl = URL(string: urlTopString)!
            let urlBottomString = self.suggessionList[countSuggesstion]["bottom"] as! String
            self.bottomUrl = URL(string: urlBottomString)!
            self.updateNumber = self.suggessionList[countSuggesstion]["numberOfTimesWorn"] as! Int
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
    
    //collection view
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggessionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SuggestCollectionViewCell.self), for: indexPath) as! SuggestCollectionViewCell
        cell.activityIndicator.startAnimating()
        FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: self.urlsOfTop[indexPath.row],newImage : cell.topImage, callback:{
            print("top image displayed")
        })
        FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: self.urlsOfBottom[indexPath.row],newImage :cell.bottomImage, callback:{
            cell.activityIndicator.stopAnimating()
          //  self.stopActivityIndicator()
            print("bottom pic displayed")
        })
         cell.activityIndicator.hidesWhenStopped = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
