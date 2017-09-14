//
//  PreviousTableViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseDatabase


class PreviousTableViewController: UITableViewController {
    var categoryOfDress: DressCategory = .other
    var userId: String = ""
    var urlsOfTop :[URL] = []
    var urlsOfBottom :[URL] = []
    var databaseref : DatabaseReference?
    var databaseHandle :DatabaseHandle?
    var storageRef: StorageReference?
    var newUser = false
    var numberOfDressesInTheCategorySelected = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Previously worn dresses"
        databaseref = Database.database().reference()
        storageRef = Storage.storage().reference()
        FirebaseReference.sharedInstance.fetchDetailsFromDatabase(userId: userId, callback: {()->() in
            for dress in detailsOfDresses{
                if dress["category"] as! String == self.categoryOfDress.rawValue{
                    self.numberOfDressesInTheCategorySelected += 1
                    print(self.numberOfDressesInTheCategorySelected)
                }
            }
            
            if self.numberOfDressesInTheCategorySelected == 0{
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
//        detailsOfDresses = []
//        keys = []
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
//                let optionMenu = UIAlertController(title: nil, message: "No previously selected dresses in \(self.categoryOfDress.rawValue) category", preferredStyle: .alert)
//                
//                let cantSuggest = UIAlertAction(title: "OK", style: .default, handler: {
//                    (alert: UIAlertAction!) -> Void in
//                    self.navigationController?.popViewController(animated: true)
//                })
//                optionMenu.addAction(cantSuggest)
//                self.present(optionMenu, animated: true, completion: nil)
//            }
//
//            for values in detailsOfDresses{
//                if values["category"] as! String == self.categoryOfDress.rawValue{
//                    let topUrlString = values["top"] as! String
//                    let topUrl = URL(string: topUrlString)
//                    self.urlsOfTop.append(topUrl!)
//                    let bottomUrlString = values["bottom"] as! String
//                    let bottomUrl = URL(string: bottomUrlString)
//                    self.urlsOfBottom.append(bottomUrl!)
//                    }
//            }
//            self.tableView.reloadData()
       // })
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
        return urlsOfTop.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousCell", for: indexPath) as? PreviousTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: urlsOfTop[indexPath.row],newImage: cell.topPreviousImage, callback: {() ->() in
            print("top image")
        })
//        Storage.storage().reference(forURL: urlsOfTop[indexPath.row] .absoluteString).getData(maxSize: 3 * 1024 * 1024, completion: { (data:Data?, error:Error?) in
//        //debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
//        let pic = UIImage(data: data!)
//        cell.topPreviousImage.image = pic
//        })
        FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: urlsOfBottom[indexPath.row],newImage: cell.bottomPreviousImage, callback: {() ->() in
            print("botom image")
        })

//        Storage.storage().reference(forURL: urlsOfBottom[indexPath.row] .absoluteString).getData(maxSize: 3 * 1024 * 1024, completion:{ (data:Data?, error:Error?) in
//        //debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
//        let pic = UIImage(data: data!)
//        cell.bottomPreviousImage.image = pic
//        })
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
