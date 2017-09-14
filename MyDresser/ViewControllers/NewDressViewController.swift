//
//  NewDressViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseDatabase
import FirebaseStorage


var keys :[Any] = []
var detailsOfDresses:[[String: AnyObject]] = []
class NewDressViewController: UIViewController, UIActionSheetDelegate{
    var dbnumber = 0
    var localTopUrl : NSURL?
    var localBottomUrl : NSURL?
    var userId: String = ""
    var categoryOfDress:DressCategory = .other
    var categoryOfPreviousDress :DressCategory = .other
    var topUrlOfPreviousDress: URL?
    var bottomUrlOfPreviousDress: URL?
    var startDatabase = 0
    var startAction = 0
    var databaseref : DatabaseReference?
    var databaseHandle :DatabaseHandle?
    var storageRef: StorageReference?
    var downloadTopUrl:URL?
    var downloadBottomUrl:URL?
    var newUser = false

    
    @IBOutlet weak var newTopImage: UIImageView!
    @IBOutlet weak var newBottomImage: UIImageView!
    let toptapGestureRecogniser = UITapGestureRecognizer()
    let bottomtapGestureRecogniser = UITapGestureRecognizer()
    let imagePicker = UIImagePickerController()
    var flag = 0    //To check if the image has to be set for top or bottom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Dress"
        print(userId)
        databaseref = Database.database().reference()
        storageRef = Storage.storage().reference()
        if let topUrl = topUrlOfPreviousDress{
            startDatabase = 1
            startAction = 0
            downloadTopUrl = topUrl
            categoryOfDress = categoryOfPreviousDress
            FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: downloadTopUrl,newImage :newTopImage, callback:{() ->() in
            print("top pic done")})
//            Storage.storage().reference(forURL: (downloadTopUrl?.absoluteString)!).getData(maxSize: 3 * 1024 * 1024, completion: { (data:Data?, error:Error?) in
//            //debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
//            let pic = UIImage(data: data!)
//            self.newTopImage.image = pic
//            
//            })
        }
        if let bottomUrl = bottomUrlOfPreviousDress{
            downloadBottomUrl = bottomUrl
            FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: downloadBottomUrl,newImage :newBottomImage, callback:{() ->() in
                print("bottom pic done")})
//            Storage.storage().reference(forURL: (downloadBottomUrl?.absoluteString)!).getData(maxSize: 3 * 1024 * 1024, completion: { (data:Data?, error:Error?) in
//               // debugPrint("error : \(error?.localizedDescription) and Data : \(data)")
//                let pic = UIImage(data: data!)
//                self.newBottomImage.image = pic
//                
//            })
        }
        toptapGestureRecogniser.addTarget(self, action: #selector(NewDressViewController.tappedTopView))
        newTopImage.isUserInteractionEnabled = true
        newTopImage.addGestureRecognizer(toptapGestureRecogniser)
        bottomtapGestureRecogniser.addTarget(self, action: #selector(NewDressViewController.tappedBottomView))
        newBottomImage.isUserInteractionEnabled = true
        newBottomImage.addGestureRecognizer(bottomtapGestureRecogniser)
        imagePicker.delegate = self
    }
    
    func tappedTopView(){
        print("image tapped")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Select from Image Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("GalleryOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 1
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cameraAction = UIAlertAction(title: "Click a new pick", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("CameraOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 1
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
       func tappedBottomView(){
        print("image tapped")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Select from Image Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("GalleryOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 2
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cameraAction = UIAlertAction(title: "Click a new pick", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("CameraOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 2
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func finaliseDressOK(_ sender: Any) {
        
        if newTopImage.image == nil && newBottomImage.image == nil{
            showAlertController(title:"No Image", message: "Select both top and bottom images!!", actionTitle: "OK")
            }
        if newTopImage.image == nil && newBottomImage.image != nil{
            showAlertController(title:"No Top Image", message: "Select the Top image!!", actionTitle: "OK")
            }
        if newTopImage.image != nil && newBottomImage.image == nil{
            showAlertController(title:"No Bottom Image", message: "Select the bottom image!!", actionTitle: "OK")
            }
        
        let attireOfTheDayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttireOfTheDayController") as! AttireOfTheDayViewController
        attireOfTheDayVC.topImage = newTopImage.image
        attireOfTheDayVC.bottomImage = newBottomImage.image
        
        // startAction is 1 only if a new dress is picked from gallery or camera
        if startAction == 1{
        print("entered due to startaction")
            FirebaseReference.sharedInstance.saveTopImageToStorage(userId: self.userId, newTopImage: self.newTopImage,categoryOfDress: self.categoryOfDress,callback: { (downloadedTopUrl) ->() in
                
                print("Top just now saved in storage after this bottom should save \(downloadedTopUrl)")
                FirebaseReference.sharedInstance.saveBottomImageToStorage (userId: self.userId, newBottomImage: self.newBottomImage,categoryOfDress: self.categoryOfDress,callback: { (downloadedBottomUrl) ->()  in
                    print("Bottom just now saved in storage after this fetch from database \(downloadedBottomUrl)")
                    FirebaseReference.sharedInstance.fetchFromDataBaseAndSaveOrUpdate(userId: self.userId, categoryOfDress: self.categoryOfDress, downloadTopUrl :downloadedTopUrl,downloadBottomUrl: downloadedBottomUrl, callback:{
                        print("now fetched from database and saved or updated")
                    })
                })
            })
        }
        
        //startDatabase is 1 only if a previously worn dress is selected
        if startDatabase == 1{
            FirebaseReference.sharedInstance.fetchFromDataBaseAndSaveOrUpdate(userId: self.userId, categoryOfDress: self.categoryOfDress, downloadTopUrl :downloadTopUrl,downloadBottomUrl: downloadBottomUrl, callback:{
                print("now fetched from database and saved or updated")
            })
         }
        self.navigationController?.pushViewController(attireOfTheDayVC, animated: true)
    }
    
    ////            saveBottomImageToStorage {()->() in
    ////                print("Bottom just now saved in storage after this fetch from database")
    ////           }
    ////            fetchFromDataBaseAndSaveOrUpdate( callback:{
    ////                    print("now fetched from database and saved or updated")
    ////                })

//    func saveTopImageToStorage(callback: @escaping () ->()){
//        var topSaveSucces = false
//        // save image of top in firebase
//        let tempImageRef = storageRef?.child(userId).child(categoryOfDress.rawValue).child((NSUUID().uuidString))
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        var imageData: Data!
//        if let image = newTopImage.image {
//            imageData = UIImageJPEGRepresentation(image, 0.8)
//        tempImageRef?.putData(imageData, metadata: nil) { metadata, error in
//            if (error != nil) {
//                print(error)
//            } else {
//                print("Upload successful for top")
//                let downloadTopURL = metadata!.downloadURL()!
//                self.downloadTopUrl = downloadTopURL
//                print("url of image downloaded is \(self.downloadTopUrl)")
//                topSaveSucces = true
//            }
//            if topSaveSucces == true{
//                print("call back just called")
//                callback()
//                
//            }
//        }
//            
//        
//        }
//    }
//    func saveBottomImageToStorage(callback: @escaping ()->()){
//        //save image of bottom in firebase
//        var bottomSaveSucces = false
//        let tempImageRef1 = self.storageRef?.child(self.userId).child(self.categoryOfDress.rawValue).child((NSUUID().uuidString))
//        let metadata1 = StorageMetadata()
//        metadata1.contentType = "image/jpeg"
//        var imageData1: Data!
//        if let image1 = self.newBottomImage.image {
//            imageData1 = UIImageJPEGRepresentation(image1, 0.8)        //convert from UIImage to Data
//            //        } else {
//            //            print("Could not find image")
//            //        }
//            _ = tempImageRef1?.putData(imageData1, metadata: nil) { metadata, error in
//                if (error != nil) {
//                    print(error)
//                } else {
//                    print("Upload successful for bottom")
//                    let downloadBottomURL = metadata!.downloadURL()!
//                    self.downloadBottomUrl = downloadBottomURL
//                    print("url of image downloaded is \(self.downloadBottomUrl)")
//                    bottomSaveSucces = true
//                }
//                if bottomSaveSucces == true{
//                    callback()
//                }
//
//            }
//        }
//        
//
//    }
//    func fetchFromDataBaseAndSaveOrUpdate(callback:()->()){
//        var indexOfDress = -1
//        detailsOfDresses = []
//        keys = []
//        self.databaseref?.child(self.userId).observeSingleEvent(of: .value, with: {(snapshot) in
//            if let dictionary = snapshot.value as? NSDictionary {
//                for(key,value) in dictionary{
//                    detailsOfDresses.append(value as! [String : AnyObject] )
//                    keys.append(key)
//                }
//            }
//            // Check if the URL of the image obtained from firebase is already present in database. If so, udate. If not save
//            for(index,values) in detailsOfDresses.enumerated(){
//                if values["category"] as! String == self.categoryOfDress.rawValue{
//                    if values["top"] as! String == self.downloadTopUrl?.absoluteString && values["bottom"] as! String == self.downloadBottomUrl?.absoluteString{
//                        self.dbnumber = values["numberOfTimesWorn"] as! Int
//                        indexOfDress = index
//                        print("index is \(indexOfDress)")
//                    }
//                }
//            }
//            if indexOfDress == -1{
//                self.databaseref?.child(self.userId).childByAutoId().setValue(["top": self.downloadTopUrl?.absoluteString, "bottom": self.downloadBottomUrl?.absoluteString, "category": self.categoryOfDress.rawValue, "numberOfTimesWorn": 1 ])
//                print("save now")
//            }
//            else{
//                print("update now")
//                self.dbnumber += 1
//                let childRef = self.databaseref?.child(self.userId).child(keys[indexOfDress] as! String)
//                childRef?.updateChildValues(["numberOfTimesWorn": self.dbnumber])
//            }
//        })
//
//    }
    

//    @IBAction func rejectDress(_ sender: Any) {
//        
//        if newUser ==  true{
//            self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
//        }
//        else{
//            self.navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
//        }
//    }
}

extension NewDressViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
              guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
          if flag == 1{
            newTopImage.image = selectedImage
        }
        else if flag == 2 {
            newBottomImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
}
