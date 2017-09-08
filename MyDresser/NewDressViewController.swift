//
//  NewDressViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos

var dresses :[Dress] = []

class NewDressViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var localTopUrl : NSURL?
    var localBottomUrl : NSURL?
    var categoryOfDress:DressCategory = .other
    
    @IBOutlet weak var newTopImage: UIImageView!
    @IBOutlet weak var newBottomImage: UIImageView!
    let toptapGestureRecogniser = UITapGestureRecognizer()
    let bottomtapGestureRecogniser = UITapGestureRecognizer()
    let imagePicker = UIImagePickerController()
    //let temperoryImage : UIImageView? = nil
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //var indexOfDress = -1
        let attireOfTheDayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttireOfTheDayController") as! AttireOfTheDayViewController
        attireOfTheDayVC.topImage = newTopImage.image
        attireOfTheDayVC.bottomImage = newBottomImage.image
        if categoryOfDress == DressCategory.casual {
            print("Casual")
            var dress = Dress()
            dress.top = localTopUrl!
            dress.bottom = localBottomUrl!
            dress.numberOfTimesWorn = 1
            dress.categorty =  .casual
            dresses.append(dress)
            for item in dresses{
                print("top is \(item.top)")
                print("bottom is \(item.bottom)")
                print("category is \(item.categorty)")
                print("number is \(item.numberOfTimesWorn)")
            }
     }
        else if categoryOfDress == DressCategory.formal {
            print("Formal")
            var dress = Dress()
            dress.top = localTopUrl!
            dress.bottom = localBottomUrl!
            dress.numberOfTimesWorn = 1
            dress.categorty =  .formal
            dresses.append(dress)
            for item in dresses{
                print("top is \(item.top)")
                print("bottom is \(item.bottom)")
                print("category is \(item.categorty)")
                print("number is \(item.numberOfTimesWorn)")
            }


        }
        else if categoryOfDress == DressCategory.ethnic {
            print("Ethnic")
            var dress = Dress()
            dress.top = localTopUrl!
            dress.bottom = localBottomUrl!
            dress.numberOfTimesWorn = 1
            dress.categorty =  .ethnic
            dresses.append(dress)
            for item in dresses{
                print("top is \(item.top)")
                print("bottom is \(item.bottom)")
                print("category is \(item.categorty)")
                print("number is \(item.numberOfTimesWorn)")
                
            }
        }
        self.navigationController?.pushViewController(attireOfTheDayVC, animated: true)
    }

    @IBAction func rejectDress(_ sender: Any) {
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

}
