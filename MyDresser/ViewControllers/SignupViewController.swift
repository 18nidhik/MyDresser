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
    
    
    @IBOutlet weak var signupButton: UIButton!
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
    let genders = ["male","female"]
    var genderString = ""
    var gradientLayer: CAGradientLayer!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Sign up"
        
        // Set corner radius for gender label
        genderLabel.layer.cornerRadius = 5
        genderLabel.layer.masksToBounds = true
        genderPicker.dataSource = self
        genderPicker.delegate = self
        emailIdText.delegate = self
        passwordText.delegate = self
        confirmPasswordText.delegate = self
        
        // Set the keyboard type of email text field as email
        emailIdText.becomeFirstResponder()
        emailIdText.keyboardType = .emailAddress
        hideKeyboardWhenTappedAround()
        
        //  Set corner radius for signup button
        signupButton.layer.cornerRadius = 8
        signupButton.layer.masksToBounds = true
        // Set corner radius for profile picture image view
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
        
        // Set images in the left view of text field
        setImageToTextField(textField: emailIdText, image:#imageLiteral(resourceName: "emailIcon"), x:0, y: 0,width: 40, height: 20)
        setImageToTextField(textField: passwordText, image:#imageLiteral(resourceName: "passwordIcon"), x:0, y: 0,width: 40, height: 20)
        setImageToTextField(textField: confirmPasswordText, image:#imageLiteral(resourceName: "confirmPasswordIcon"), x:0, y: 0,width: 40, height: 20)
        gradientLayer = CAGradientLayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Make navigation bar visible
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        createGradientLayer(view: self.view, gradientLayer: self.gradientLayer)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        if isFace ==  true{
            performSignUpAction()
        }
        else{
            showAlertController(title:"Error" , message: "Enter valid pic", actionTitle: "OK")
        }
    }
    
    func setProfilePic(){
        
        print("image tapped")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
        // When image gallery is selected
        let galleryAction = UIAlertAction(title: "Select from Image Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("GalleryOpened")
            // Check if the app has permission to access gallery
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
            
            // Check if the device has camera
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
    
    func performSignUpAction(){
        
        let enteredEmailId =  emailIdText.text
        let enteredPassword = passwordText.text
        let enteredConfirmPassword = confirmPasswordText.text
        
        // Show alert if any of the text fields are empty
        guard let emailId = enteredEmailId, let password = enteredPassword, let confirmPassword = enteredConfirmPassword, !emailId.isEmpty, !password.isEmpty, profilePic.image != nil, !genderString.isEmpty  else {
            showAlertController(title:"Error" , message: "Please fill all the details correctly", actionTitle: "OK")
            return
        }
        
        // Show alert if the entered passwords do not match
        guard password == confirmPassword else{
            showAlertController(title:"Error" , message: "Passwords do not match", actionTitle: "OK")
            return
        }
        startActivityIndicatorForView(spinner:self.spinner,view:self.view, style:UIActivityIndicatorViewStyle.whiteLarge,x: (self.view.bounds.midX - 30), y: (self.view.bounds.maxY - 100), width: 60.0, height: 60.0)
        
        // Authenticate the user
        Authentication.sharedInstance.createUser(emailId: emailId, password: password, callback: {(_ signupSuccess: Bool, _ uid: String)->() in
            self.stopActivityIndicatorForView(spinner:self.spinner)
            if signupSuccess == true{
                // Sace the profile picture to firebase storage
                FirebaseReference.sharedInstance.saveProfileImageToStorage(userId: uid, newImage: self.profilePic, callback: { (downloadedUrl) ->() in
                    print("profile pic  just now saved in storage after this bottom should save")
                    // Save the url of profile picture in firebase
                    FirebaseReference.sharedInstance.updateProfilePicDetails(userId: uid, downloadUrl: downloadedUrl,gender:self.genderString,  callback:{()->() in
                        UserDefaults.standard.set(uid, forKey: "userID")
                        UserDefaults.standard.set(emailId, forKey: "emailID")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(true, forKey: "loginStatus")
                        UserDefaults.standard.set(true, forKey: "newUser")
                        let login = UserDefaults.standard.bool(forKey: "loginStatus")
                        print("user defaults value of login status is \(login)")
                        let tabBarVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"TabBarController") as! TabBarViewController
                        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = tabBarVC
                    })
                })
            }
            else{
                self.showAlertController(title: "Error" , message: uid, actionTitle: "OK")
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
        startActivityIndicatorForImage(spinner: spinnerPic,newImage: profilePic, style:UIActivityIndicatorViewStyle.gray, x: 30.0, y: 30.0, width: 60.0, height: 60.0)
        dismiss(animated: true) {
            
            self.checkFace(onImage: selectedImage)
            
            if self.isFace == true{
                self.stopActivityIndicatorForImage(spinner: (self.spinnerPic))
                self.profilePic.image = selectedImage
            }
            else{
                self.stopActivityIndicatorForImage(spinner: (self.spinnerPic))
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
            showAlertController(title:"Error" , message: "Choose valid profile pic", actionTitle: "OK")
        }
    }
}

