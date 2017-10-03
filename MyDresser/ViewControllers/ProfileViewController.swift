//
//  ProfileViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 25/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos
import Vision

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var changePassword: UITextField!
    @IBOutlet weak var changeEmail: UITextField!
    @IBOutlet weak var profileEmail: UILabel!
 //   @IBOutlet weak var save: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    var options = ["View dresses","Change emailId","Change password"]
    var userId = ""
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let imagePicker = UIImagePickerController()
    var isFace = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uniqueId = UserDefaults.standard.string(forKey: "userID"){
            userId = uniqueId
            print(userId)
        }
        self.navigationItem.title = "My Profile"
      //  save.isHidden = true
        profileTableView.delegate =  self
        profileTableView.dataSource = self
        profileEmail.text = UserDefaults.standard.string(forKey: "emailID")
        profileImage.layer.cornerRadius = 60
        profileImage.layer.masksToBounds = true

        
        // Remove the separotor between cells
        profileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1).cgColor
        startActivityIndicatorForImage(spinner: spinner,newImage: profileImage,style:UIActivityIndicatorViewStyle.gray, x: 30.0, y: 30.0, width: 60.0, height: 60.0)
        FirebaseReference.sharedInstance.fetchProfilePicFromDatabase(userId: userId, callback: { (fetchedProfilePicUrl)->() in
            if let profilePicUrl = fetchedProfilePicUrl {
                self.profileImage.loadImageUsingCacheWithURLString(URLString: profilePicUrl.absoluteString, onCompletion: {()->() in
                    self.stopActivityIndicatorForImage(spinner: self.spinner)
                })
            }else {
                self.profileImage.image = #imageLiteral(resourceName: "profilePicIcon")
            }
           // self.stopActivityIndicatorForImage(spinner: self.spinner)
        })
        imagePicker.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  save.isHidden = true
        profileEmail.text = UserDefaults.standard.string(forKey: "emailID")
    }
    
    @IBAction func changeProfilePic(_ sender: Any) {
        setProfilePicture()
       // save.isHidden = false
    }
    
    @IBAction func saveProfilePic(_ sender: Any) {
       // saveProfilePicture()
    }
    func saveProfilePicture(){
        FirebaseReference.sharedInstance.saveProfileImageToStorage(userId: userId, newImage: self.profileImage, callback: { (downloadedUrl) ->() in
            print("profile pic  just now changed and  saved in storage after this bottom should save")
            FirebaseReference.sharedInstance.updateProfilePicChanges(userId: self.userId, updatedProfileImageUrl: downloadedUrl, callback: { ()->() in
                print("new profile pic url stored in database")
                self.showAlertController(title:"Trendz" , message: "Profile pic changed successfully.", actionTitle: "OK")
           //     self.save.isHidden = true
            })
        })
    }
    func setProfilePicture(){
        
        print("image tapped")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        optionMenu.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    // Title for each row in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        cell.profileLabel.text = options[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow;
        if indexPath?.row == 0{
            let profilePreviousVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ProfilePreviousController") as! ProfilePreviousTableViewController
            profilePreviousVC.userId = self.userId
            self.navigationController?.pushViewController(profilePreviousVC, animated: true)
        }
            
        else if indexPath?.row == 1 {
            let changeCredentialsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChangeCredentials") as! ChangeCredentials
            changeCredentialsVC.credentialType = .email
            self.navigationController?.pushViewController( changeCredentialsVC, animated: true)
        }
        else if indexPath?.row == 2 {
            let changeCredentialsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ChangeCredentials") as! ChangeCredentials
            changeCredentialsVC.credentialType = .password
            self.navigationController?.pushViewController( changeCredentialsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        startActivityIndicatorForImage(spinner: spinner,newImage: profileImage, style:UIActivityIndicatorViewStyle.gray, x: 30.0, y: 30.0, width: 60.0, height: 60.0)//
        dismiss(animated: true) {
            
            self.checkFace(onImage: selectedImage)
            if self.isFace == true{
                self.stopActivityIndicatorForImage(spinner: (self.spinner))//
                self.profileImage.image = selectedImage
                self.saveProfilePicture()
            }
            else{
                self.stopActivityIndicatorForImage(spinner: (self.spinner))//
                if self.profileImage.image == nil{
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

