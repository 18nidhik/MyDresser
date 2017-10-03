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
    @IBOutlet weak var suggestMeSomethingElseButton: UIButton!
    
    
    @IBOutlet weak var suggestionOkButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
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
    var urlsOfTop :[URL] = []
    var urlsOfBottom :[URL] = []
    var gradientLayer: CAGradientLayer!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.delegate =  self
        collectionView.dataSource = self
        countSuggesstion = 0
        navigationItem.title = "Suggested Attire"
        suggestMeSomethingElseButton.layer.cornerRadius = 8
        suggestMeSomethingElseButton.layer.masksToBounds = true
        suggestMeSomethingElseButton.layer.borderWidth = 2
        suggestMeSomethingElseButton.layer.borderColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
        suggestionOkButton.layer.cornerRadius = 8
        suggestionOkButton.layer.masksToBounds = true
        detailsOfDresses = []
        keys = []
        startActivityIndicatorForView(spinner:self.spinner, view:self.view, style:UIActivityIndicatorViewStyle.gray, x: (collectionView.frame.width/2)-30, y: collectionView.frame.midY-30, width: 60, height: 60)
        collectionView.register(UINib(nibName: String(describing: SuggestCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SuggestCollectionViewCell.self))
        
        // Fetch details from firebase and check if there are previously worn dresses in selected category
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
                self.stopActivityIndicatorForView(spinner:self.spinner)
                let optionMenu = UIAlertController(title: nil, message: "No suggestions since you have no previously selected dresses in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
                optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
                let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    if self.newUser == true{
                        self.navigationController?.popToRootViewController(animated: true)
                        //self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                    }
                    else{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
                optionMenu.addAction(cantSuggest)
                self.present(optionMenu, animated: true, completion: nil)
            }
            else{
                
                self.stopActivityIndicatorForView(spinner:self.spinner)
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
                        self.suggessionList.append(values)
                    }
                }
                
                //get the list of top and bottom image urls
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
                for values in self.suggessionList{
                    for (key, value) in values{
                        print("\(key) :\(value)")
                    }
                }
                //get the top and bottom image url of first suggested attire
                let urlTopString = self.suggessionList[0]["top"] as! String
                self.topUrl = URL(string: urlTopString)!
                let urlBottomString = self.suggessionList[0]["bottom"] as! String
                self.bottomUrl = URL(string: urlBottomString)!
                self.updateNumber = self.suggessionList[0]["numberOfTimesWorn"] as! Int
                
                // get the index of the suggested attire for updating
                for(index,values) in detailsOfDresses.enumerated(){
                    if values["category"] as! String == self.categoryOfDress.rawValue{
                        if values["top"] as? String == self.topUrl?.absoluteString && values["bottom"] as? String == self.bottomUrl?.absoluteString{
                            self.indexOfSuggestedDress = index
                            print("index is \(self.indexOfSuggestedDress)")
                        }
                    }
                }
            }
            self.collectionView.reloadData()
        })
        gradientLayer = CAGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        createGradientLayerForButton(view: self.suggestionOkButton, gradientLayer: self.gradientLayer)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "barImage") , for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
    @IBAction func suggestOkAction(_ sender: Any) {
        
        //Update the number of times the suggested dress is worn when clicked OK
        print("update now")
        updateNumber += 1
        FirebaseReference.sharedInstance.updateDatabase(userId: self.userId, key: keys[indexOfSuggestedDress] as! String,updateNumber: self.updateNumber, callback: {()->() in
            if self.newUser == true{
                self.navigationController?.popToRootViewController(animated: true)
                // self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
            }
            else{
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    @IBAction func suggestMeSomethingElse(_ sender: Any) {
        
        countSuggesstion += 1
        if countSuggesstion < suggessionList.count{
            
            //scroll to the next item on button click
            let indexPath = NSIndexPath(row: countSuggesstion, section: 0)
            collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            
            // get the top and bottom urls of suggested sttire
            let urlTopString = self.suggessionList[countSuggesstion]["top"] as! String
            self.topUrl = URL(string: urlTopString)!
            let urlBottomString = self.suggessionList[countSuggesstion]["bottom"] as! String
            self.bottomUrl = URL(string: urlBottomString)!
            self.updateNumber = self.suggessionList[countSuggesstion]["numberOfTimesWorn"] as! Int
            
            // get the index of suggested attire for updating
            for(index,values) in detailsOfDresses.enumerated(){
                if values["category"] as! String == self.categoryOfDress.rawValue{
                    if values["top"] as? String == self.topUrl?.absoluteString && values["bottom"] as? String == self.bottomUrl?.absoluteString{
                        self.indexOfSuggestedDress = index
                        print("index is \(self.indexOfSuggestedDress)")
                    }
                }
            }
        }
            // If the suggession count is greater than number of dresses in the selected category show a alert
        else{
            let optionMenu = UIAlertController(title: nil, message: "No more dresses to suggest in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
            optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
            let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                if self.newUser == true{
                    self.navigationController?.popToRootViewController(animated: true)
                    // self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                }
                else{
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
            optionMenu.addAction(cantSuggest)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    //Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggessionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SuggestCollectionViewCell.self), for: indexPath) as! SuggestCollectionViewCell
        cell.activityIndicator.startAnimating()
        cell.topImage.loadImageUsingCacheWithURLString(URLString: urlsOfTop[indexPath.row].absoluteString, onCompletion: {()->() in
            
        })
        cell.bottomImage.loadImageUsingCacheWithURLString(URLString: urlsOfBottom[indexPath.row].absoluteString, onCompletion: {()->() in
           cell.activityIndicator.stopAnimating()
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
