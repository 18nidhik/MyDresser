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

class SuggestViewController: UIViewController {

    @IBOutlet weak var suggestedTopImage: UIImageView!
    @IBOutlet weak var suggestedBottomImage: UIImageView!
    var userId: String = ""
    var categoryOfDress:DressCategory = .other
    var suggestedDress = Dress()
    var databaseref : DatabaseReference?
    var databaseHandle :DatabaseHandle?
    var topUrl: URL?
    var bottomUrl: URL?
    var indexOfSuggestedDress = -1
    var updateNumber = 0
    var newUser = false
    var numberOfDressesInTheCategorySelected = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Suggested Attire"
        databaseref = Database.database().reference()
        detailsOfDresses = []
        keys = []
        FirebaseReference.sharedInstance.fetchDetailsFromDatabase(userId: userId, callback: {()->() in
         print("Details fetched from database ")
            for dress in detailsOfDresses{
                if dress["category"] as! String == self.categoryOfDress.rawValue{
                    self.numberOfDressesInTheCategorySelected += 1
                    print(self.numberOfDressesInTheCategorySelected)
                }
            }
            
            if self.numberOfDressesInTheCategorySelected == 0{
                let optionMenu = UIAlertController(title: nil, message: "No suggestions since you have no previously selected dresses in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
                
                let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    
                    if self.newUser == true{
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                    }
                    else{
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                    }
                })
                optionMenu.addAction(cantSuggest)
                self.present(optionMenu, animated: true, completion: nil)
            }
            
            
            // sort the array in decreasing order
            for values in detailsOfDresses.sorted(by: { (lhs, rhs) -> Bool in
                if let leftValue = lhs["numberOfTimesWorn"], let leftInt = leftValue as? Int, let rightValue = rhs["numberOfTimesWorn"], let rightInt = rightValue as? Int {
                    return leftInt > rightInt
                } else {
                    return false // NOTE: you will need to decide how to handle missing keys and non-int values.
                }
            }){
                if values["category"] as! String == self.categoryOfDress.rawValue{
                    let urlTopString = values["top"] as! String
                    self.topUrl = URL(string: urlTopString)!
                    let urlBottomString = values["bottom"] as! String
                    self.bottomUrl = URL(string: urlBottomString)!
                    self.updateNumber = values["numberOfTimesWorn"] as! Int
                    FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: self.topUrl,newImage :self.suggestedTopImage, callback:{
                    print("top image displayed")
                    })
                        FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: self.bottomUrl,newImage :self.suggestedBottomImage, callback:{
                            //() ->() in
                            print("bottom pic displayed")
                        })
                            print("Details after suggested dress selected")
                            for(index,values) in detailsOfDresses.enumerated(){
                                if values["category"] as! String == self.categoryOfDress.rawValue{
                                    if values["top"] as! String == self.topUrl?.absoluteString && values["bottom"] as! String == self.bottomUrl?.absoluteString{
                                        self.indexOfSuggestedDress = index
                                        print("index is \(self.indexOfSuggestedDress)")
                                    }
                                }
                            }
                            return
                        
                    
//                    Storage.storage().reference(forURL: (self.topUrl!.absoluteString)).getData(maxSize: 3 * 1024 * 1024, completion: { (data:Data?, error:Error?) in
//                        //debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
//                        let pic = UIImage(data: data!)
//                        self.suggestedTopImage.image = pic
//                        
//                    })
//                    Storage.storage().reference(forURL: (self.bottomUrl!.absoluteString)).getData(maxSize: 3 * 1024 * 1024, completion: { (data:Data?, error:Error?) in
//                        //debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
//                        let pic = UIImage(data: data!)
//                        self.suggestedBottomImage.image = pic
//                        
//                    })
                    
//                    print("Details after suggested dress selected")
//                    for(index,values) in detailsOfDresses.enumerated(){
//                        if values["category"] as! String == self.categoryOfDress.rawValue{
//                            if values["top"] as! String == self.topUrl?.absoluteString && values["bottom"] as! String == self.bottomUrl?.absoluteString{
//                                self.indexOfSuggestedDress = index
//                                print("index is \(self.indexOfSuggestedDress)")
//                            }
//                        }
//                    }
//                    return
                }
            }

    })
        
        
//        databaseref?.child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
//            if let dictionary = snapshot.value as? NSDictionary {
//                for(key,value) in dictionary{
//                    detailsOfDresses.append(value as! [String : AnyObject] )
//                    keys.append(key)
//                }
//            }
//            for dress in detailsOfDresses{
//                if dress["category"] as! String == self.categoryOfDress.rawValue{
//                    self.numberOfDressesInTheCategorySelected += 1
//                    print(self.numberOfDressesInTheCategorySelected)
//                }
//            }
//            
//            if self.numberOfDressesInTheCategorySelected == 0{
//                let optionMenu = UIAlertController(title: nil, message: "No suggestions since you have no previously selected dresses in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
//                
//                let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
//                    (alert: UIAlertAction!) -> Void in
//                    
//                    if self.newUser == true{
//                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
//                    }
//                    else{
//                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
//                    }
//                })
//                optionMenu.addAction(cantSuggest)
//                self.present(optionMenu, animated: true, completion: nil)
//            }
//            
//            
//            // sort the array in decreasing order
//            for values in detailsOfDresses.sorted(by: { (lhs, rhs) -> Bool in
//                if let leftValue = lhs["numberOfTimesWorn"], let leftInt = leftValue as? Int, let rightValue = rhs["numberOfTimesWorn"], let rightInt = rightValue as? Int {
//                    return leftInt > rightInt
//                } else {
//                    return false // NOTE: you will need to decide how to handle missing keys and non-int values.
//                }
//            }){
//                    if values["category"] as! String == self.categoryOfDress.rawValue{
//                        let urlTopString = values["top"] as! String
//                        self.topUrl = URL(string: urlTopString)!
//                        let urlBottomString = values["bottom"] as! String
//                        self.bottomUrl = URL(string: urlBottomString)!
//                        self.updateNumber = values["numberOfTimesWorn"] as! Int
//                        Storage.storage().reference(forURL: (self.topUrl!.absoluteString)).getData(maxSize: 3 * 1024 * 1024, completion: { (data:Data?, error:Error?) in
//                        //debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
//                        let pic = UIImage(data: data!)
//                        self.suggestedTopImage.image = pic
//                        
//                })
//                        Storage.storage().reference(forURL: (self.bottomUrl!.absoluteString)).getData(maxSize: 3 * 1024 * 1024, completion: { (data:Data?, error:Error?) in
//                            //debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
//                            let pic = UIImage(data: data!)
//                            self.suggestedBottomImage.image = pic
//                            
//                        })
//
//                        print("Details after suggested dress selected")
//                        for(index,values) in detailsOfDresses.enumerated(){
//                            if values["category"] as! String == self.categoryOfDress.rawValue{
//                                if values["top"] as! String == self.topUrl?.absoluteString && values["bottom"] as! String == self.bottomUrl?.absoluteString{
//                                    self.indexOfSuggestedDress = index
//                                    print("index is \(self.indexOfSuggestedDress)")
//                                }
//                            }
//                        }
//                        return
//                    }
//                }
       // })
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func suggestedDressOk(_ sender: Any) {
        print("update now")
        updateNumber += 1
        FirebaseReference.sharedInstance.updateDatabase(userId: self.userId, key: keys[indexOfSuggestedDress] as! String,updateNumber: self.updateNumber, callback: {()->() in
            if self.newUser == true{
                self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
            }
            else{
                self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
            }
        })
//        let childRef = self.databaseref?.child(userId).child(keys[indexOfSuggestedDress] as! String)
//        childRef?.updateChildValues(["numberOfTimesWorn": self.updateNumber])
//        if self.newUser == true{
//           self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
//        }
//        else{
//         self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
//        }
    }
   
    @IBAction func suggestedDressReject(_ sender: Any) {
        if self.newUser == true{
            self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
        }
        else{
            self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
        }
    }
}
