//
//  NewDressViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos

var keys :[Any] = []
var detailsOfDresses:[[String: AnyObject]] = []

class NewDressViewController: UIViewController, UIActionSheetDelegate{
    
    var userId: String = ""
    var categoryOfDress:DressCategory = .other
    var categoryOfPreviousDress :DressCategory = .other
    var topUrlOfPreviousDress: URL?
    var bottomUrlOfPreviousDress: URL?
    var startDatabase = 0
    var startAction = 0
    var downloadTopUrl:URL?
    var downloadBottomUrl:URL?
    var newUser = false
    let spinner1 = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let spinner2 = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    @IBOutlet weak var newTopImage: UIImageView!
    @IBOutlet weak var newBottomImage: UIImageView!
    let toptapGestureRecogniser = UITapGestureRecognizer()
    let bottomtapGestureRecogniser = UITapGestureRecognizer()
    let imagePicker = UIImagePickerController()
    var flag = 0    //To check if the image has to be set for top or bottom
    let labelTop = UILabel(frame: CGRect(x: 60, y: 50, width: 300, height: 50))
    let labelBottom = UILabel(frame: CGRect(x: 60, y: 50, width: 300, height: 50))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "New Dress"
        print(userId)
        labelTop.text = "Tap to select the pic"
        labelTop.textColor = UIColor.black
        if newTopImage.image == nil{
            newTopImage.addSubview(labelTop)
        }
        
        labelBottom.text = "Tap to select the pic"
        labelBottom.textColor = UIColor.black
        if newBottomImage.image == nil{
            newBottomImage.addSubview(labelBottom)
        }
        
        // If a previously worn dress is selected display the top image
        if let topUrl = topUrlOfPreviousDress{
            startDatabase = 1
            startAction = 0
            downloadTopUrl = topUrl
            categoryOfDress = categoryOfPreviousDress
            labelTop.isHidden = true
            startActivityIndicator(spinner: spinner1,newImage: newTopImage)
            FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: downloadTopUrl,newImage :newTopImage, callback:{() ->() in
                self.stopActivityIndicator(spinner: self.spinner1)
                print("top pic done")})
        }
        
        // If a previously worn dress is selected display the bottom image
        if let bottomUrl = bottomUrlOfPreviousDress{
            downloadBottomUrl = bottomUrl
            labelBottom.isHidden = true
            startActivityIndicator(spinner: spinner2,newImage: newBottomImage)
            FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: downloadBottomUrl,newImage :newBottomImage, callback:{() ->() in
                self.stopActivityIndicator(spinner: self.spinner2)
                print("bottom pic done")})
        }
        
        // tap on top image to select a new top attire
        toptapGestureRecogniser.addTarget(self, action: #selector(NewDressViewController.tappedTopView))
        newTopImage.isUserInteractionEnabled = true
        newTopImage.addGestureRecognizer(toptapGestureRecogniser)
        //Tap on bottom image to select a new bottom attire
        bottomtapGestureRecogniser.addTarget(self, action: #selector(NewDressViewController.tappedBottomView))
        newBottomImage.isUserInteractionEnabled = true
        newBottomImage.addGestureRecognizer(bottomtapGestureRecogniser)
        imagePicker.delegate = self
    }
    
    // When the top image is tapped provide options to click a new image or or select from image gallery
    func tappedTopView(){
        
        print("image tapped")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        // When image gallery is selected
        let galleryAction = UIAlertAction(title: "Select from Image Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("GalleryOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 1
            self.photoLibraryAccessCheck(completion: { ()->() in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        })
        // When camera option is selected
        let cameraAction = UIAlertAction(title: "Click a new pic", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("CameraOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 1
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.checkCameraPermission(completion: {() ->() in
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker,animated: true,completion: nil)
                })
            } else {
                self.noCamera()
            }
        })
        // When cancel is seleted
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // When the bottom image is tapped provide options to click a new image or or select from image gallery
    func tappedBottomView() {
        
        print("image tapped")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        // When image galley is selected
        let galleryAction = UIAlertAction(title: "Select from Image Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("GalleryOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 2
            self.photoLibraryAccessCheck(completion: { ()->() in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.imagePicker, animated: true, completion: nil)
                
            })
        })
        // When camera option is selected
        let cameraAction = UIAlertAction(title: "Click a new pic", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("CameraOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 2
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.checkCameraPermission(completion: {() ->() in
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker,animated: true,completion: nil)
                })
            } else {
                self.noCamera()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    //When cancel is selected
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    
    // Check if the camera access permission is granted or not
    func checkCameraPermission(completion: @escaping ()->())  {
        
        let cameraMediaType = AVMediaTypeVideo
        AVCaptureDevice.requestAccess(forMediaType: cameraMediaType) { granted in
            if granted {
                completion()
            } else {
                self.noAccessFound()
                print("Denied access for camera ")
            }
        }
    }
    
    //Check if Photo library access permission is granted or not
    func photoLibraryAccessCheck(completion: ()->())
    {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            completion()
            print("Access for photo library granted'")
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            self.noAccessFound()
        }
    }
    
    // When the camera or gallery access is denied provide alert to the user to go to sttings and enable it
    func noAccessFound(){
        
        let alert = UIAlertController(title: "MyDresser", message: "Please allow camera access in phone settings", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction) in
        }));
        alert.addAction(UIAlertAction(title: "Open setting ", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }));
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //start spinner
    func startActivityIndicator(spinner:UIActivityIndicatorView, newImage: UIImageView){
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
        spinner.frame = CGRect(x: 140.0, y: 70.0, width: 60.0, height: 60.0)
        newImage.addSubview(spinner)
        spinner.startAnimating()    }
    
    //stop spinner
    func stopActivityIndicator(spinner:UIActivityIndicatorView){
        spinner.stopAnimating()
    }
    
    @IBAction func finaliseDressOK(_ sender: Any) {
        
        if newTopImage.image == nil && newBottomImage.image == nil{
            showAlertController(title:"No Image", message: "Select both top and bottom dresses!!", actionTitle: "OK")
        }
        if newTopImage.image == nil && newBottomImage.image != nil{
            showAlertController(title:"No Top Image", message: "Select the Top attire!!", actionTitle: "OK")
        }
        if newTopImage.image != nil && newBottomImage.image == nil{
            showAlertController(title:"No Bottom Image", message: "Select the bottom attire!!", actionTitle: "OK")
        }
        let attireOfTheDayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttireOfTheDayController") as! AttireOfTheDayViewController
        attireOfTheDayVC.topImage = newTopImage.image
        attireOfTheDayVC.bottomImage = newBottomImage.image
        attireOfTheDayVC.newUser = self.newUser
        
        // startAction is 1 only if a new dress is picked from gallery or camera
        if startAction == 1{
            print("entered due to startaction")
            FirebaseReference.sharedInstance.saveImageToStorage(userId: self.userId, newImage: self.newTopImage,categoryOfDress: self.categoryOfDress,callback: { (downloadedTopUrl) ->() in
                print("Top just now saved in storage after this bottom should save")
                FirebaseReference.sharedInstance.saveImageToStorage (userId: self.userId, newImage: self.newBottomImage,categoryOfDress: self.categoryOfDress,callback: { (downloadedBottomUrl) ->()  in
                    print("Bottom just now saved in storage after this fetch from database ")
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
}

// Image picker delegate methods
extension NewDressViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        if flag == 1{
            labelTop.isHidden = true
            newTopImage.image = selectedImage
        }
        else if flag == 2 {
            labelBottom.isHidden = true
            newBottomImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
