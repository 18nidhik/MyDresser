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
    var categoryOfDress:DressCategory = .other
    var suggestedDress = Dress()
    var databaseref : DatabaseReference?
    var databaseHandle :DatabaseHandle?
    var topUrl = NSURL()
    var bottomUrl = NSURL()
    var indexOfSuggestedDress = -1
    var updateNumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()
   //     dresses.sorted(by: {$0.numberOfTimesWorn > $1.numberOfTimesWorn})
        
        databaseref = Database.database().reference()
        
        detailsOfDresses = []
        keys = []
        databaseref?.child("dresses").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                for(key,value) in dictionary{
                    detailsOfDresses.append(value as! [String : AnyObject] )
                    keys.append(key)
                }
                print("first")
                for(index,values) in detailsOfDresses.enumerated(){
                    print("index is \(index)")
                    for(key,val) in values{
                        print("\(key) s value is \(val)")
                    }
                }
                
                print("list of keys")
                for key in keys{
                    print(key)
                }
            }
            print("second")
            for(index,values) in detailsOfDresses.enumerated(){
                print("index is \(index)")
                for(key,val) in values{
                    print("\(key) s value is \(val)")
                }
            }
            
            print("sorted")
            for values in detailsOfDresses.sorted(by: { (lhs, rhs) -> Bool in
                if let leftValue = lhs["numberOfTimesWorn"], let leftInt = leftValue as? Int, let rightValue = rhs["numberOfTimesWorn"], let rightInt = rightValue as? Int {
                    return leftInt > rightInt
                } else {
                    return false // NOTE: you will need to decide how to handle missing keys and non-int values.
                }
            }){
                    if values["category"] as! String == self.categoryOfDress.rawValue{
                        let urlTopString = values["top"] as! String
                        self.topUrl = NSURL(string: urlTopString)!
                        let urlBottomString = values["bottom"] as! String
                        self.bottomUrl = NSURL(string: urlBottomString)!
                        self.updateNumber = values["numberOfTimesWorn"] as! Int
                        let asset = PHAsset.fetchAssets(withALAssetURLs: [self.topUrl as URL], options: nil)
                        guard let result = asset.firstObject else {
                            return
                        }
                        let imageManager = PHImageManager.default()
                        var imageData: Data? = nil
                        imageManager.requestImageData(for: result, options: nil, resultHandler: { (data, string, orientation, dict) in
                            imageData = data
                            self.suggestedTopImage.image = UIImage(data: imageData!)
                        })
                        let asset1 = PHAsset.fetchAssets(withALAssetURLs: [self.bottomUrl as URL], options: nil)
                        guard let result1 = asset1.firstObject else {
                            return
                        }
                        let imageManager1 = PHImageManager.default()
                        var imageData1: Data? = nil
                        imageManager1.requestImageData(for: result1, options: nil, resultHandler: { (data, string, orientation, dict) in
                            imageData1 = data
                            self.suggestedBottomImage.image = UIImage(data: imageData1!)
                        })
                        print("Suggested")
                        for(index,values) in detailsOfDresses.enumerated(){
                            if values["category"] as! String == self.categoryOfDress.rawValue{
                                if values["top"] as! String == self.topUrl.absoluteString && values["bottom"] as! String == self.bottomUrl.absoluteString{
                                    self.indexOfSuggestedDress = index
                                    print("index is \(self.indexOfSuggestedDress)")
                                }
                            }
                        }
                        
                        return

                    }
                
            }
        })
        
    // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func suggestedDressOk(_ sender: Any) {
        print("update now")
        updateNumber += 1
        let childRef = self.databaseref?.child("dresses").child(keys[indexOfSuggestedDress] as! String)
        childRef?.updateChildValues(["numberOfTimesWorn": self.updateNumber])
        self.navigationController?.popToRootViewController(animated: true)
    }
   
    @IBAction func suggestedDressReject(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
