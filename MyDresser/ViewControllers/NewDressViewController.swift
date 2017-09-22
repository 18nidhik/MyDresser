//
//  NewDressViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos
import Vision
import CoreML


var keys :[Any] = []
var detailsOfDresses:[[String: AnyObject]] = []

class NewDressViewController: UIViewController, UIActionSheetDelegate{
    
    @IBOutlet weak var dressLabel: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    var userId: String = ""
    var categoryOfDress:DressCategory = .other
    var categoryOfPreviousDress :DressCategory = .other
    var topUrlOfPreviousDress: URL?
    var bottomUrlOfPreviousDress: URL?
    var startDatabase = 0
    var startAction = 0
    var downloadTopUrl:URL?
    var downloadBottomUrl:URL?
    var fetchedProfilePicUrl: URL?
    var newUser = false
    let spinner1 = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let spinner2 = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let spinner3 = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    @IBOutlet weak var newTopImage: UIImageView!
    @IBOutlet weak var newBottomImage: UIImageView!
    let toptapGestureRecogniser = UITapGestureRecognizer()
    let bottomtapGestureRecogniser = UITapGestureRecognizer()
    let imagePicker = UIImagePickerController()
    var flag = 0    //To check if the image has to be set for top or bottom
    let labelTop = UILabel(frame: CGRect(x: 80, y: 50, width: 300, height: 50))
    let labelBottom = UILabel(frame: CGRect(x: 80, y: 50, width: 300, height: 50))
    var newDressOk:UIBarButtonItem = UIBarButtonItem()
    var labelOfPreviousDress = ""
    var labelOfDress = ""
    var topKeywords = ["jersey, T-shirt, tee shirt","jersey", "T-shirt", "tee shirt","sweatshirt", "suit, suit of clothes","suit", "suit of clothes","velvet"]
    var bottomKeywords = ["jean, blue jean, denim","jean","blue jean","denim","pajama, pyjama, pj\'s, jammies","pajama","pyjama","suit, suit of clothes","suit","suit of clothes"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "New Dress"
        profilePic.layer.cornerRadius = 60
        profilePic.layer.masksToBounds = true
        hideKeyboardWhenTappedAround()
       // labelOfDress = dressLabel.text ?? ""
        let newDressOk = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(newDressOkAction))
        self.navigationItem.setRightBarButtonItems([newDressOk], animated: true)
        //profilePic.clipsToBounds = true
        //profilePic.layoutIfNeeded()
        startActivityIndicator(spinner: spinner3,newImage: profilePic, x: 30.0, y: 30.0, width: 60.0, height: 60.0)
        FirebaseReference.sharedInstance.fetchProfilePicFromDatabase(userId: userId, callback: { (fetchedProfilePicUrl)->() in
            FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: fetchedProfilePicUrl,newImage :self.profilePic, callback:{() ->() in
                self.stopActivityIndicator(spinner: self.spinner3)
                print("profile pic done")
            })
            
        })
        
        
        print(userId)
        labelTop.text = "Tap to select the top pic"
        labelTop.textColor = UIColor.black
        if newTopImage.image == nil{
            newTopImage.addSubview(labelTop)
        }
        
        labelBottom.text = "Tap to select the bottom pic"
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
            dressLabel.text = labelOfPreviousDress
            labelTop.isHidden = true
           // newTopImage.backgroundColor = nil
            startActivityIndicator(spinner: spinner1,newImage: newTopImage,x: 140.0, y: 50.0, width: 60.0, height: 60.0)
            FirebaseReference.sharedInstance.downloadImageFromFirebase(downloadUrl: downloadTopUrl,newImage :newTopImage, callback:{() ->() in
                self.stopActivityIndicator(spinner: self.spinner1)
                print("top pic done")})
        }
        
        // If a previously worn dress is selected display the bottom image
        if let bottomUrl = bottomUrlOfPreviousDress{
            downloadBottomUrl = bottomUrl
            labelBottom.isHidden = true
            startActivityIndicator(spinner: spinner2,newImage: newBottomImage, x: 140.0, y: 50.0, width: 60.0, height: 60.0)
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
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    }
                else {
                    }
            })
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
    func startActivityIndicator(spinner:UIActivityIndicatorView, newImage: UIImageView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
        spinner.frame = CGRect(x: x, y: y, width: width, height: height)
        newImage.addSubview(spinner)
        spinner.startAnimating()
        
    }
    
    //stop spinner
    func stopActivityIndicator(spinner:UIActivityIndicatorView){
        spinner.stopAnimating()
    }
    
    func newDressOkAction(){
        labelOfDress = dressLabel.text ?? ""
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
                    FirebaseReference.sharedInstance.fetchFromDataBaseAndSaveOrUpdate(userId: self.userId, categoryOfDress: self.categoryOfDress, downloadTopUrl :downloadedTopUrl,downloadBottomUrl: downloadedBottomUrl,label: self.labelOfDress, callback:{
                        print("now fetched from database and saved or updated")
                    })
                })
            })
        }
        
        //startDatabase is 1 only if a previously worn dress is selected
        if startDatabase == 1{
            FirebaseReference.sharedInstance.fetchFromDataBaseAndSaveOrUpdate(userId: self.userId, categoryOfDress: self.categoryOfDress, downloadTopUrl :downloadTopUrl,downloadBottomUrl: downloadBottomUrl,label: self.labelOfDress, callback:{
                print("now fetched from database and saved or updated")
            })
        }
        self.navigationController?.pushViewController(attireOfTheDayVC, animated: true)
    }
}

// Image picker delegate methods
extension NewDressViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var textFound : Bool = false
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        if flag == 1{
            labelTop.isHidden = true
           // newTopImage.backgroundColor = nil
           // newTopImage.image = selectedImage
             print("processing")
            startActivityIndicator(spinner: spinner1,newImage: newTopImage,x: 140.0, y: 50.0, width: 60.0, height: 60.0)
         //   processImage((newTopImage.image?.cgImage!)!) { [weak self] text in
            processImage((selectedImage.cgImage!)) { [weak self] text in
                //self?.textView.text = text
                print("received text from ml is \(text)")
                for items in (self?.topKeywords)!{
                    for value in text{
                        if value == items{
                            textFound = true
                            print(value)
                        }
                    }
                }
                if textFound == true{
                    print("matched")
                    self?.stopActivityIndicator(spinner: (self?.spinner1)!)
                    self?.newTopImage.image = selectedImage
                }
                else{
                    print("not matched")
                    self?.stopActivityIndicator(spinner: (self?.spinner1)!)
                   self?.showAlertController(title:"Try Again" , message: "Enter the picture of Dress only", actionTitle: "OK")
                    if self?.newTopImage.image == nil{
                  //  self?.newTopImage.backgroundColor = UIColor.white
                    self?.labelTop.isHidden = false
                    }
                }
            }
        }
        else if flag == 2 {
            labelBottom.isHidden = true
          //  newBottomImage.image = selectedImage
             print("processing")
            startActivityIndicator(spinner: spinner2,newImage: newBottomImage,x: 140.0, y: 50.0, width: 60.0, height: 60.0)
            processImage((selectedImage.cgImage!)) { [weak self] text in
                //self?.textView.text = text
                print("received text from ml is \(text)")
                for items in (self?.bottomKeywords)!{
                    for value in text{
                        if value == items{
                            textFound = true
                            print(value)
                        }
                    }
                }
                if textFound == true{
                    print("matched")
                    self?.stopActivityIndicator(spinner: (self?.spinner2)!)
                    self?.newBottomImage.image = selectedImage
                }
                else{
                    print("not matched")
                    self?.stopActivityIndicator(spinner: (self?.spinner2)!)
                    self?.showAlertController(title:"Try Again" , message: "Enter the picture of dress only", actionTitle: "OK")
                    if self?.newBottomImage.image == nil{
                        self?.labelBottom.isHidden = false
                    }
                }
            }
        }
       dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func processImage(_ image: CGImage, completion: @escaping ([String])->Void ){

        DispatchQueue.global(qos: .background).async {

            //Init Core Vision Model
            if #available(iOS 11.0, *) {
                guard let vnCoreModel = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
            //Init Core Vision Request
            let request = VNCoreMLRequest(model: vnCoreModel) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else { fatalError("Failure") }
                var text :[String] = []
                var count = 0
                for classification in results {
                    count += 1
                    if count < 11{
                    text.append(classification.identifier)
                    }
                }
//                  display all results
//                for classification in results {
//                    text.append("\n" + "\(classification.identifier, classification.confidence)")
//                }

                DispatchQueue.main.async {
                    completion(text)
                }
            }
            //Init Core Vision Request Handler
            let handler = VNImageRequestHandler(cgImage: image)

            //Perform Core Vision Request
            do {
                try handler.perform([request])
            } catch {
                print("did throw on performing a VNCoreRequest")
            }
        } else {
            // Fallback on earlier versions
                let keywords = self.topKeywords+self.bottomKeywords
                completion(keywords)
        }
        }
    }
   
}
