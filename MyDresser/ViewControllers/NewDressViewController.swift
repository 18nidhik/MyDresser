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
    
    
    @IBOutlet weak var newDressOkButton: UIButton!
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
    let labelTop = UILabel(frame: CGRect(x: 80, y: 35, width: 300, height: 50))
    let labelBottom = UILabel(frame: CGRect(x: 80, y: 35, width: 300, height: 50))
    var labelOfPreviousDress = ""
    var labelOfDress = ""
    var topKeywords = ["jersey, T-shirt, tee shirt","jersey", "T-shirt", "tee shirt","sweatshirt", "suit, suit of clothes","suit", "suit of clothes","velvet"]
    var bottomKeywords = ["jean, blue jean, denim","jean","blue jean","denim","pajama, pyjama, pj\'s, jammies","pajama","pyjama","suit, suit of clothes","suit","suit of clothes"]
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "New Attire"
        profilePic.layer.cornerRadius = 50
        profilePic.layer.masksToBounds = true
        profilePic.layer.borderWidth = 1
        profilePic.layer.borderColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
        dressLabel.layer.borderWidth = 1
        dressLabel.layer.borderColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
        dressLabel.layer.cornerRadius = 10
        dressLabel.layer.masksToBounds = true
        newDressOkButton.layer.cornerRadius = 10
        newDressOkButton.layer.masksToBounds = true
        newTopImage.layer.borderWidth = 0.5
        newTopImage.layer.borderColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
        newBottomImage.layer.borderWidth = 0.5
        newBottomImage.layer.borderColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
        hideKeyboardWhenTappedAround()
        startActivityIndicatorForImage(spinner: spinner3,newImage: profilePic,style:UIActivityIndicatorViewStyle.gray, x: 22.0, y: 22.0, width: 60.0, height: 60.0)
        // Fetch details of profile picture from firebase and display
        FirebaseReference.sharedInstance.fetchProfilePicFromDatabase(userId: userId, callback: { (fetchedProfilePicUrl)->() in
            if let profilePicUrl = fetchedProfilePicUrl {
                self.profilePic.loadImageUsingCacheWithURLString(URLString: profilePicUrl.absoluteString, onCompletion: {()->() in
                    self.stopActivityIndicatorForImage(spinner: self.spinner3)
                })
            }else {
                self.profilePic.image = #imageLiteral(resourceName: "profilePicIcon")
            }
          //  self.stopActivityIndicatorForImage(spinner: self.spinner3)
        })
        
        print(userId)
        labelTop.text = "Tap to select the top pic"
        labelTop.textColor = UIColor.lightGray
        if newTopImage.image == nil{
            newTopImage.addSubview(labelTop)
        }
        labelBottom.text = "Tap to select the bottom pic"
        labelBottom.textColor = UIColor.lightGray
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
            startActivityIndicatorForImage(spinner: spinner1,newImage: newTopImage,style:UIActivityIndicatorViewStyle.gray,x: 140.0, y: 50.0, width: 60.0, height: 60.0)
            if let topPicUrl = downloadTopUrl {
                self.newTopImage.loadImageUsingCacheWithURLString(URLString: topPicUrl.absoluteString, onCompletion: {()->() in
                    self.stopActivityIndicatorForImage(spinner: self.spinner1)
                })
            }else {
                self.newTopImage.image = #imageLiteral(resourceName: "arrowButton")
            }
           // self.stopActivityIndicatorForImage(spinner: self.spinner1)
        }
        
        // If a previously worn dress is selected display the bottom image
        if let bottomUrl = bottomUrlOfPreviousDress{
            
            downloadBottomUrl = bottomUrl
            labelBottom.isHidden = true
            startActivityIndicatorForImage(spinner: spinner2,newImage: newBottomImage,style:UIActivityIndicatorViewStyle.gray, x: 140.0, y: 50.0, width: 60.0, height: 60.0)
            if let bottomPicUrl = downloadBottomUrl {
                self.newBottomImage.loadImageUsingCacheWithURLString(URLString: bottomPicUrl.absoluteString, onCompletion: {()->() in
                    self.stopActivityIndicatorForImage(spinner: self.spinner2)
                })
            }else {
                self.newBottomImage.image = #imageLiteral(resourceName: "arrowButton")
            }
          //  self.stopActivityIndicatorForImage(spinner: self.spinner2)
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
        gradientLayer = CAGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        createGradientLayerForButton(view: newDressOkButton, gradientLayer: self.gradientLayer)
    }
    
    // When the top image is tapped provide options to click a new image or or select from image gallery
    func tappedTopView(){
        
        print("image tapped")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
        
        // When image gallery is selected in actionsheet
        let galleryAction = UIAlertAction(title: "Select from Image Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("GalleryOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 1
            // Check if the app has permission to access gallery
            self.photoLibraryAccessCheck(completion: { ()->() in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        })
        
        // When camera option is selected in actionsheet
        let cameraAction = UIAlertAction(title: "Click a new pic", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("CameraOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 1
            
            // Check if the device has camera or not
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // Check if the app has permission to access camera
                self.checkCameraPermission(completion: {() ->() in
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker,animated: true,completion: nil)
                })
            }
                // If the device has no camera
            else {
                self.noCamera()
            }
        })
        
        // When cancel is seleted in actionsheet
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
        optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
        
        // When image galley is selected in action sheet
        let galleryAction = UIAlertAction(title: "Select from Image Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("GalleryOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 2
            
            // Check if the app has permission to access galery
            self.photoLibraryAccessCheck(completion: { ()->() in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        })
        // When camera option is selected in actionsheet
        let cameraAction = UIAlertAction(title: "Click a new pic", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("CameraOpened")
            self.startDatabase = 0
            self.startAction = 1
            self.flag = 2
            // Check if the device has camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // Check if the app has permission to access the camera
                self.checkCameraPermission(completion: {() ->() in
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker,animated: true,completion: nil)
                })
            }
                // if the device has no camera
            else {
                self.noCamera()
            }
        })
        
        //When cancel is selected in actionsheet
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func newDressOkAction(_ sender: Any) {
        
        labelOfDress = dressLabel.text ?? ""
        if newTopImage.image == nil && newBottomImage.image == nil{
            showAlertController(title:"Error", message: "Select both top and bottom attires!!", actionTitle: "OK")
        }
        if newTopImage.image == nil && newBottomImage.image != nil{
            showAlertController(title:"Error", message: "Select the top attire!!", actionTitle: "OK")
        }
        if newTopImage.image != nil && newBottomImage.image == nil{
            showAlertController(title:"Error", message: "Select the bottom attire!!", actionTitle: "OK")
        }
        
        let attireOfTheDayVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttireOfTheDayController") as! AttireOfTheDayViewController
        attireOfTheDayVC.topImage = newTopImage.image
        attireOfTheDayVC.bottomImage = newBottomImage.image
        attireOfTheDayVC.newUser = self.newUser
        
        // startAction is 1 only if a new dress is picked from gallery or camera
        if startAction == 1{
            print("entered due to startaction")
            // Save top image to storage
            FirebaseReference.sharedInstance.saveImageToStorage(userId: self.userId, newImage: self.newTopImage,categoryOfDress: self.categoryOfDress,callback: { (downloadedTopUrl) ->() in
                // Save bottom image to storage
                FirebaseReference.sharedInstance.saveImageToStorage (userId: self.userId, newImage: self.newBottomImage,categoryOfDress: self.categoryOfDress,callback: { (downloadedBottomUrl) ->()  in
                    // Save details of dress in database
                    FirebaseReference.sharedInstance.fetchFromDataBaseAndSaveOrUpdate(userId: self.userId, categoryOfDress: self.categoryOfDress, downloadTopUrl :downloadedTopUrl,downloadBottomUrl: downloadedBottomUrl,label: self.labelOfDress, callback:{
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
            print("processing")
            startActivityIndicatorForImage(spinner: spinner1,newImage: newTopImage,style:UIActivityIndicatorViewStyle.gray,x: 140.0, y: 45.0, width: 60.0, height: 60.0)
            // Check if the image uploaded is of dress
            processImage((selectedImage.cgImage!)) { [weak self] text in
                print("received text from ml is \(text)")
                // Compare with the dress keywords
                for items in (self?.topKeywords)!{
                    for value in text{
                        if value == items{
                            textFound = true
                            print(value)
                        }
                    }
                }
                // If the prediction matched with keywords
                if textFound == true{
                    print("matched")
                    self?.stopActivityIndicatorForImage(spinner: (self?.spinner1)!)
                    self?.newTopImage.image = selectedImage
                }
                else{
                    print("not matched")
                    self?.stopActivityIndicatorForImage(spinner: (self?.spinner1)!)
                    self?.showAlertController(title:"Error" , message: "Choose the picture of top only", actionTitle: "OK")
                    if self?.newTopImage.image == nil{
                        self?.labelTop.isHidden = false
                    }
                }
            }
        }
        else if flag == 2 {
            labelBottom.isHidden = true
            print("processing")
            startActivityIndicatorForImage(spinner: spinner2,newImage: newBottomImage,style:UIActivityIndicatorViewStyle.gray,x: 140.0, y: 45.0, width: 60.0, height: 60.0)
            // Check if the image uploaded is of dress
            processImage((selectedImage.cgImage!)) { [weak self] text in
                print("received text from ml is \(text)")
                // Compare with the dress keywords
                for items in (self?.bottomKeywords)!{
                    for value in text{
                        if value == items{
                            textFound = true
                            print(value)
                        }
                    }
                }
                // If the prediction matched with keywords
                if textFound == true{
                    print("matched")
                    self?.stopActivityIndicatorForImage(spinner: (self?.spinner2)!)
                    self?.newBottomImage.image = selectedImage
                }
                else{
                    print("not matched")
                    self?.stopActivityIndicatorForImage(spinner: (self?.spinner2)!)
                    self?.showAlertController(title:"Error" , message: "Choose the picture of bottom only", actionTitle: "OK")
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
            
            if #available(iOS 11.0, *) {
                //Init Core Vision Model
                guard let vnCoreModel = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
                //Init Core Vision Request
                let request = VNCoreMLRequest(model: vnCoreModel) { (request, error) in
                    guard let results = request.results as? [VNClassificationObservation] else { fatalError("Failure") }
                    var text :[String] = []
                    var count = 0
                    // Take only top 10 predictions
                    for classification in results {
                        count += 1
                        if count < 11{
                            text.append(classification.identifier)
                        }
                    }
//                    //display all results
//                    for classification in results {
//                        text.append("\n" + "\(classification.identifier, classification.confidence)")
//                    }
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
