//
//  SignupViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 11/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos
import Vision

class SignupViewController: UIViewController, UITextFieldDelegate, UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate  {

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let spinnerPic = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let imageTapGestureRecogniser = UITapGestureRecognizer()
    let imagePicker = UIImagePickerController()
    let labelImage = UILabel(frame: CGRect(x: 5, y: 10, width: 115, height: 100))
    var isFace = false
    var signup:UIBarButtonItem = UIBarButtonItem()
    let genders = ["male","female"]
    var genderString = ""
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Sign up"
        genderLabel.layer.cornerRadius = 5
        genderLabel.layer.masksToBounds = true
        genderPicker.dataSource = self
        genderPicker.delegate = self
        emailIdText.delegate = self
        passwordText.delegate = self
        confirmPasswordText.delegate = self
        emailIdText.keyboardType = .emailAddress
        hideKeyboardWhenTappedAround()
        profilePic.layer.cornerRadius = 60
        profilePic.layer.masksToBounds = true
        imageTapGestureRecogniser.addTarget(self, action: #selector(SignupViewController.setProfilePic))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(imageTapGestureRecogniser)
        imagePicker.delegate = self
        labelImage.text = "Tap to select the profile pic"
        labelImage.numberOfLines = 2
        labelImage.textColor = UIColor.black
        if profilePic.image == nil{
            profilePic.addSubview(labelImage)
        }
        let signup = UIBarButtonItem.init(title: "Signup", style: .plain, target: self, action: #selector(signupAction))
        self.navigationItem.setRightBarButtonItems([signup], animated: true)
    }
    
    func signupAction(){
        if isFace ==  true{
            performSignUpAction()
        }
        else{
            showAlertController(title:"Try Again" , message: "Enter valid pic", actionTitle: "OK")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    func setProfilePic(){
        
        print("image tapped")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        // When image gallery is selected
        let galleryAction = UIAlertAction(title: "Select from Image Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("GalleryOpened")
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
    
    func performSignUpAction(){
        
        let enteredEmailId =  emailIdText.text
        let enteredPassword = passwordText.text
        let enteredConfirmPassword = confirmPasswordText.text
        
        guard let emailId = enteredEmailId, let password = enteredPassword, let confirmPassword = enteredConfirmPassword, !emailId.isEmpty, !password.isEmpty, profilePic.image != nil, !genderString.isEmpty  else {
            showAlertController(title:"Try Again" , message: "Please fill all the details correctly", actionTitle: "OK")
            return
        }
        guard password == confirmPassword else{
            showAlertController(title:"Try Again" , message: "Passwords do not match", actionTitle: "OK")
            return
        }
        startActivityIndicator()
        Authentication.sharedInstance.createUser(emailId: emailId, password: password, callback: {(_ signupSuccess: Bool, _ uid: String)->() in
            
            self.stopActivityIndicator()
            if signupSuccess == true{
                FirebaseReference.sharedInstance.saveProfileImageToStorage(userId: uid, newImage: self.profilePic, callback: { (downloadedUrl) ->() in
                    print("profile pic  just now saved in storage after this bottom should save")
                    FirebaseReference.sharedInstance.updateProfilePicDetails(userId: uid, downloadUrl: downloadedUrl,gender:self.genderString,  callback:{()->() in
                        UserDefaults.standard.set(uid, forKey: "userID")
                        UserDefaults.standard.set(true, forKey: "loginStatus")
                        UserDefaults.standard.set(true, forKey: "newUser")
                        let login = UserDefaults.standard.bool(forKey: "loginStatus")
                        print("user defaults value of login status is \(login)")
                        let chooseOrSuggestTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChooseOrSuggestController") as! ChooseOrSuggestTableViewController
                        // chooseOrSuggestTVC.userUniqueId = uid
                        // chooseOrSuggestTVC.newUser = true
                        self.navigationController?.pushViewController(chooseOrSuggestTVC, animated: true)

                    })
                })
            }
            else{
                self.showAlertController(title: "Try again" , message: uid, actionTitle: "OK")
            }
        })
    }
    
    //dismiss the keyboard on tapping return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.confirmPasswordText.isFirstResponder {
            self.confirmPasswordText.resignFirstResponder()
            performSignUpAction()
        } else if self.emailIdText.isFirstResponder {
            self.emailIdText.resignFirstResponder()
            self.passwordText.becomeFirstResponder()
        } else{
            self.passwordText.resignFirstResponder()
            self.confirmPasswordText.becomeFirstResponder()
        }
        return true
    }
    
    // Start spinner
    func startActivityIndicator(){
        
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.whiteLarge
        spinner.frame = CGRect(x: (self.view.bounds.midX - 30), y: (self.view.bounds.maxY - 100), width: 60.0, height: 60.0)
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    //Stop spinner
    func stopActivityIndicator(){
        spinner.stopAnimating()
    }
    
    //start spinner
    func startActivityIndicatorforPic(spinner:UIActivityIndicatorView, newImage: UIImageView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
        spinner.frame = CGRect(x: x, y: y, width: width, height: height)
        newImage.addSubview(spinner)
        spinner.startAnimating()
        
    }
    
    //stop spinner
    func stopActivityIndicatorforPic(spinner:UIActivityIndicatorView){
        spinner.stopAnimating()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    // Number of rows in each component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    // On each category click action
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderString = genders[row]
    }
    
    // Provide colour for the text in each row
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = genders[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
   
    
}

// Image picker delegate methods
extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.labelImage.isHidden = true
         startActivityIndicatorforPic(spinner: spinnerPic,newImage: profilePic,x: 30.0, y: 30.0, width: 60.0, height: 60.0)
        dismiss(animated: true) {
//            self.labelImage.isHidden = true
            //self.profilePic.image = selectedImage
           self.checkFace(onImage: selectedImage)
          //  self.stopActivityIndicator(spinner: (self.spinnerPic))
            if self.isFace == true{
                self.stopActivityIndicatorforPic(spinner: (self.spinnerPic))
                self.profilePic.image = selectedImage
            }
            else{
                self.stopActivityIndicatorforPic(spinner: (self.spinnerPic))
                if self.profilePic.image == nil{
                    self.labelImage.isHidden = false
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func checkFace(onImage image:UIImage){
        print("checkface entered")
     //   startActivityIndicator(spinner: spinnerPic,newImage: profilePic,x: 60.0, y: 30.0, width: 60.0, height: 60.0)
        if #available(iOS 11.0, *) {
            let detectFaceRequest: VNDetectFaceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)

            let detectFaceRequestHandler = VNImageRequestHandler(cgImage: (image.cgImage)!, options: [:])
        do {
            try detectFaceRequestHandler.perform([detectFaceRequest])
        } catch let error {
            print("error is here \(error.localizedDescription) and error : \(error)")
            print(error)
        }
        } else {
            // Fallback on earlier versions
            isFace = true
        }
    }
    @available(iOS 11.0, *)
    func handleFaces(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation]
            else { fatalError("unexpected result type") }
        print(observations.count)
        if observations.count == 1{
            isFace = true
        }
        else{
            isFace = false
            showAlertController(title:"Try Again" , message: "Enter valid profile pic", actionTitle: "OK")
        }
    }
}

