//
//  FirebaseReference.swift
//  MyDresser
//
//  Created by Shrinidhi K on 14/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FirebaseReference{
    var databaseref : DatabaseReference?
    var storageRef: StorageReference?
    var downloadedUrl :URL?
    var dbUpdateNumberOfTimesWorn = 0
    
    static let sharedInstance = FirebaseReference()
    
    // Save the new top and bottom image to databse
    func saveImageToStorage(userId: String, newImage: UIImageView,categoryOfDress: DressCategory, callback: @escaping (_ downloadedUrl: URL?) ->()) {
        storageRef = Storage.storage().reference()
        
        var SaveSuccess = false
        // save image of top in firebase
        let tempImageRef = storageRef?.child(userId).child(categoryOfDress.rawValue).child((NSUUID().uuidString))
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        var imageData: Data!
        if let image = newImage.image {
            imageData = UIImageJPEGRepresentation(image, 0.8)
            tempImageRef?.putData(imageData, metadata: nil) { metadata, error in
                if (error != nil) {
                    print(error ?? "error")
                } else {
                    print("Upload successful")
                    let downloadTopURL = metadata!.downloadURL()!
                    self.downloadedUrl = downloadTopURL
                    print("url of image downloaded is \(String(describing: self.downloadedUrl))")
                    SaveSuccess = true
                }
                if SaveSuccess == true {
                    print("call back just called")
                    callback(self.downloadedUrl)
                }
            }
        }
    }
    
    // fetch details from database to check if the image is already present in database.
    func fetchFromDataBaseAndSaveOrUpdate(userId: String, categoryOfDress: DressCategory, downloadTopUrl :URL?,downloadBottomUrl: URL?,callback:@escaping ()->()){
        databaseref = Database.database().reference()
        var indexOfDress = -1  // To check if the details of dress is already present in database.
        detailsOfDresses = []
        keys = []
        print("entered fetch")
        self.databaseref?.child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                for(key,value) in dictionary{
                    detailsOfDresses.append(value as! [String : AnyObject] )
                    keys.append(key)
                }
                for values in detailsOfDresses{
                    for (key,value) in values{
                        print("\(key) s value is \(value)")
                    }
                }
            }
            // Check if the URL of the image is already present in database. If so, udate. If not save
            for(index,values) in detailsOfDresses.enumerated(){
                if values["category"] as! String == categoryOfDress.rawValue{
                    if values["top"] as! String == downloadTopUrl?.absoluteString && values["bottom"] as! String == downloadBottomUrl?.absoluteString{
                        self.dbUpdateNumberOfTimesWorn = values["numberOfTimesWorn"] as! Int
                        indexOfDress = index
                        print("index is \(indexOfDress)")
                    }
                }
            }
            if indexOfDress == -1{
                self.databaseref?.child(userId).childByAutoId().setValue(["top": downloadTopUrl?.absoluteString, "bottom": downloadBottomUrl?.absoluteString, "category": categoryOfDress.rawValue, "numberOfTimesWorn": 1 ])
                print("save now")
            }
            else{
                print("update now")
                self.dbUpdateNumberOfTimesWorn += 1
                let childRef = self.databaseref?.child(userId).child(keys[indexOfDress] as! String)
                childRef?.updateChildValues(["numberOfTimesWorn": self.dbUpdateNumberOfTimesWorn])
            }
            callback()
        })
    }
    
    // download the top and bottom image from firebase
    func downloadImageFromFirebase(downloadUrl: URL?,newImage :UIImageView, callback: @escaping () ->()){
        Storage.storage().reference(forURL: (downloadUrl?.absoluteString)!).getData(maxSize: 3 * 1024 * 1024, completion: { (data:Data?, error:Error?) in
            //debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
            let pic = UIImage(data: data!)
            newImage.image = pic
            callback()
        })
    }
    
    //Fetch details from firebase
    func fetchDetailsFromDatabase(userId: String, callback: @escaping ()->()){
        databaseref = Database.database().reference()
        detailsOfDresses = []
        keys = []
        databaseref?.child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                for(key,value) in dictionary{
                    detailsOfDresses.append(value as! [String : AnyObject] )
                    keys.append(key)
                }
            }
            callback()
            
        })
    }
    
    // Update the deatils in firebase
    func updateDatabase(userId: String, key: String,updateNumber: Int, callback: ()->()){
        databaseref = Database.database().reference()
        let childRef = databaseref?.child(userId).child(key)
        childRef?.updateChildValues(["numberOfTimesWorn": updateNumber])
        callback()
        
    }
}
