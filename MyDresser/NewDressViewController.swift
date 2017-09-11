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

var dresses :[Dress] = []
var keys :[Any] = []

var detailsOfDresses:[[String: AnyObject]] = []
class NewDressViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var dbnumber = 0
    var localTopUrl : NSURL?
    var localBottomUrl : NSURL?
    var categoryOfDress:DressCategory = .other
    var categoryOfPreviousDress :DressCategory = .other
    var topUrlOfPreviousDress: NSURL?
    var bottomUrlOfPreviousDress: NSURL?
    var databaseref : DatabaseReference?
    var databaseHandle :DatabaseHandle?

    
    @IBOutlet weak var newTopImage: UIImageView!
    @IBOutlet weak var newBottomImage: UIImageView!
    let toptapGestureRecogniser = UITapGestureRecognizer()
    let bottomtapGestureRecogniser = UITapGestureRecognizer()
    let imagePicker = UIImagePickerController()
    //let temperoryImage : UIImageView? = nil
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseref = Database.database().reference()
        if let topUrl = topUrlOfPreviousDress{
            localTopUrl = topUrl
            categoryOfDress = categoryOfPreviousDress
            let asset = PHAsset.fetchAssets(withALAssetURLs: [topUrl as URL], options: nil)
                        guard let result = asset.firstObject else {
                            return
                        }
                        let imageManager = PHImageManager.default()
                        var imageData: Data? = nil
                        imageManager.requestImageData(for: result, options: nil, resultHandler: { (data, string, orientation, dict) in
                            imageData = data
                            self.newTopImage.image = UIImage(data: imageData!)
                        })

        }
        if let bottomUrl = bottomUrlOfPreviousDress{
            localBottomUrl = bottomUrl
            let asset = PHAsset.fetchAssets(withALAssetURLs: [bottomUrl as URL], options: nil)
            guard let result = asset.firstObject else {
                return
            }
            let imageManager = PHImageManager.default()
            var imageData: Data? = nil
            imageManager.requestImageData(for: result, options: nil, resultHandler: { (data, string, orientation, dict) in
                imageData = data
                self.newBottomImage.image = UIImage(data: imageData!)
            })

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
            self.flag = 1
            //let imagePicker = UIImagePickerController()
            //imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cameraAction = UIAlertAction(title: "Click a new pick", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("CameraOpened")
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
            self.flag = 2
            //let imagePicker = UIImagePickerController()
            //imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cameraAction = UIAlertAction(title: "Click a new pick", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("CameraOpened")
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

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        
//        if let localUrl = info[UIImagePickerControllerReferenceURL] as? NSURL {
//            print(localUrl)
//            let asset = PHAsset.fetchAssets(withALAssetURLs: [localUrl as URL], options: nil)
//            guard let result = asset.firstObject else {
//                return
//            }
//            let imageManager = PHImageManager.default()
//            var imageData: Data? = nil
//            imageManager.requestImageData(for: result, options: nil, resultHandler: { (data, string, orientation, dict) in
//                imageData = data
//                self.newTopImage.image = UIImage(data: imageData!)
//            })
//        }
//          picker.dismiss(animated: true, completion: nil)
        
        
        
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
       
        //newTopImage.contentMode = .scaleAspectFit
        if self.flag == 1{
            localTopUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
            newTopImage.image = selectedImage
        }
        else if flag == 2 {
             localBottomUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
            newBottomImage.image = selectedImage
        }
       // temperoryImage?.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func finaliseDressOK(_ sender: Any) {
       var indexOfDress = -1
        let attireOfTheDayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttireOfTheDayController") as! AttireOfTheDayViewController
        attireOfTheDayVC.topImage = newTopImage.image
        attireOfTheDayVC.bottomImage = newBottomImage.image
        
    
         detailsOfDresses = []
        keys = []
        databaseref?.child("dresses").observeSingleEvent(of: .value, with: {(snapshot) in
//            print(snapshot)
//            print("now values")
//            print(snapshot.value)
            
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
//                print("second")
//                for(index,values) in detailsOfDresses.enumerated(){
//                    print("index is \(index)")
//                    for(key,val) in values{
//                        print("\(key) s value is \(val)")
//                    }
//                }

            }
            print("second")
                            for(index,values) in detailsOfDresses.enumerated(){
                                print("index is \(index)")
                                for(key,val) in values{
                                    print("\(key) s value is \(val)")
                                }
                            }
            for(index,values) in detailsOfDresses.enumerated(){
                            if values["category"] as! String == self.categoryOfDress.rawValue{
                                if values["top"] as! String == self.localTopUrl?.absoluteString && values["bottom"] as! String == self.localBottomUrl?.absoluteString{
                                    self.dbnumber = values["numberOfTimesWorn"] as! Int
                                    indexOfDress = index
                                    print("index is \(indexOfDress)")
                                }
                            }
                        }
            if indexOfDress == -1{
                self.databaseref?.child("dresses").childByAutoId().setValue(["top": self.localTopUrl?.absoluteString!, "bottom": self.localBottomUrl?.absoluteString!, "category": self.categoryOfDress.rawValue, "numberOfTimesWorn": 1 ])
                print("save now")
            }
            else{
                print("update now")
                self.dbnumber += 1
               let childRef = self.databaseref?.child("dresses").child(keys[indexOfDress] as! String)
                childRef?.updateChildValues(["numberOfTimesWorn": self.dbnumber])
                //update
                // dresses[indexOfDress].numberOfTimesWorn += 1
            }




            
        })
//        print("dress array")
//         for(index,values) in detailsOfDresses.enumerated(){
//            print("index is \(index)")
//            var dress1 = Dress()
//            let b = NSURL(string: values["bottom"] as! String)
//            dress1.bottom = b!
//            let t = NSURL(string: values["top"] as! String)
//            dress1.top = t!
//            var c = DressCategory(rawValue: values["category"] as! String)
//            dress1.categorty = c!
//            dress1.numberOfTimesWorn = values["numberOfTimesWorn"] as! Int
//            dresses.append(dress1)
//            }
        
//        for(index,values) in detailsOfDresses.enumerated(){
//            if values["category"] as! String == categoryOfDress.rawValue{
//                if values["top"] as! String == localTopUrl?.absoluteString && values["bottom"] as! String == localBottomUrl?.absoluteString{
//                    indexOfDress = index
//                }
//            }
//        }
        

//        for (index,dress) in dresses.enumerated(){
//                if dress.categorty == categoryOfDress{
//                if dress.top == localTopUrl && dress.bottom == localBottomUrl{
//                    indexOfDress = index
//                }
//              }
//            }
        
//            if indexOfDress == -1{
//        databaseref?.child("dresses").childByAutoId().setValue(["top": localTopUrl?.absoluteString!, "bottom": localBottomUrl?.absoluteString!, "category": categoryOfDress.rawValue, "numberOfTimesWorn": 1 ])
//        }
//            else{
//                //up[date
//               // dresses[indexOfDress].numberOfTimesWorn += 1
//            }
        self.navigationController?.pushViewController(attireOfTheDayVC, animated: true)
    }

    @IBAction func rejectDress(_ sender: Any) {
       
//     databaseref?.child("dresses").observeSingleEvent(of: .value, with: {(snapshot) in
//            print(snapshot)
//            print("now values")
//            print(snapshot.value)
//
//                                if let dictionary = snapshot.value as? NSDictionary {
//                            for(key,value) in dictionary{
//                                //keys.append(key)
//                                detailsOfDresses.append(value as! [String : AnyObject] )
//                            }
////                                    print("keys only")
////                                    for key in keys{
////                                        print("key")
////                                    }
//                                    print("values only")
//                            for(index,values) in detailsOfDresses.enumerated(){
//                                print("index is \(index)")
//                                for(key,val) in values{
//                                    print("\(key) s value is \(val)")
//                                }
//                            }
//                 }
//        
//        })
        

          self.navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*
     
     
     //        let imageURL = info[UIImagePickerControllerReferenceURL] as! URL
     //        print("url is \(imageURL)")
     //      //  let path = imageURL.path!
     //        let imageName = imageURL.lastPathComponent
     //        print("imageName is\(String(describing: imageName))")
     //        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
     //        print("path is \(paths)")
     //        let documentDirectory = paths.first as String!
     //        print("first path is \(String(describing: paths.first))")
     //        let localPath = documentDirectory! + "/" + imageName
     //        print("local path is \(localPath)")
     //        let imageData = NSData(contentsOfFile: localPath)
     //        newTopImage.image = UIImage(data: imageData as! Data)
     //
     ////        if let imageData = NSData(contentsOfFile: String(describing: imageURL)) as Data? {
     ////            let newImage = UIImage(data: imageData)
     ////            newTopImage.image = newImage
     ////        }
     
     //
     
     
     
     // let image = info[UIImagePickerControllerOriginalImage] as! UIImage
     //let data = NSData(contentsOf: url!)
     //        let imageName = imageUrl?.lastPathComponent
     //        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
     //        let photoURL = NSURL(fileURLWithPath: documentDirectory)
     //        let localPath = photoURL.appendingPathComponent(imageName!)
     //       // newTopImage.image = info[UIImagePickerControllerOriginalImage]as? UIImage
     ////        let imageData = NSData(contentsOfFile: localPath)
     ////        newTopImage.image = UIImage(data: imageData as Data)
     //       // newTopImage.image = UIImage(contentsOfFile: (localPath?.absoluteString)!)
     //        newTopImage.image = UIImage(contentsOfFile: imageName!)
     //        dismiss(animated: true, completion: nil)
     //
     //        if !FileManager.default.fileExists(atPath: localPath!.path) {
     //            do {
     //                try UIImageJPEGRepresentation(image, 1.0)?.write(to: localPath!)
     //                print("file saved")
     //            }catch {
     //                print("error saving file")
     //            }
     //        }
     //        else {
     //            print("file already exists")
     //        }


 */
    
    
    //                        let top = dictionary["top"] as? String
    //                            print("top is")
    //                            print(top!)
    //                            print("Dictionary")
    //                            for (key,value) in dictionary{
    //                                detailsOfDresses.append(value as! [String : AnyObject])
    //                            }

    
    
    
    //                            for (index,values) in detailsOfDresses{
    //                                print("\(index) details are")
    //                                for(key,value) in values{
    //
    //                                print( "\(key) s value is  \(value)")
    //                                }
    //                            }
    // detailsOfDresses.append(dictionary as! [String : AnyObject] )
    
    
    //                        print("details of dictionary")
    //                        for (index,item) in detailsOfDresses.enumerated(){
    //                            print("\(index) element is    ")
    //                            for(key,value) in item{
    //                                print("\(key) is \(value)")
    //                            }
    //                        }

    //-------------------
/*    //        databaseref?.child("dresses").queryOrderedByKey().observeSingleEvent(of: <#T##DataEventType#>, with: <#T##(DataSnapshot) -> Void#>)
    databaseref?.child("dresses").observeSingleEvent(of: .value, with: {(snapshot) in
    print(snapshot)
    print("now values")
    print(snapshot.value)
    // snapshot.value
    //            if let top = snapshot.value["top"] as? String{
    //                print(top)
    //            }
    
    //            if let dictionary = snapshot.value as? NSDictionary {
    //            let top = dictionary["top"] as? String
    //                print("top is")
    //                print(top!)
    //                print("Dictionary")
    //                for (key,value) in dictionary{
    //                    detailsOfDresses.append(value as! [String : AnyObject])
    //                }
    //   detailsOfDresses.append(dictionary )
    //     }
    //            print("details of dictionary")
    //            for item in detailsOfDresses{
    //                for(key,value) in item{
    //                    print("\(key) is \(value)")
    //                }
    //            }
    
    })
    //        databaseref?.child("dresses").observeSingleEvent(of: .value, with: { (snapshot) in
    //            print(snapshot)
    //            if let dictionary = snapshot.value as? [String: AnyObject] {
    //          //  detailsOfDresses.setValuesForKeys(dictionary)
    //                detailsOfDresses.append(dictionary)
    //           // self.roomlist.append(meetingRoom)
    //
    //              }
    //       }
    //  .observe(.childAdded, with: { (snapshot) in
    //            if let dictionary = snapshot.value as? [String: AnyObject] {
    //                let meetingRoom = MeetingRoom()
    //
    //                meetingRoom.setValuesForKeys(dictionary)
    //                self.roomlist.append(meetingRoom)
    //                print(meetingRoom)
    //                DispatchQueue.main.async(execute: {
    //                    self.tableView.reloadData()
    //                })
    //            }
    //            print(self.roomlist)
    //            
    //        })*/



}
