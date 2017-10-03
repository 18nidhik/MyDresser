//
//  Utilities.swift
//  MyDresser
//
//  Created by Shrinidhi K on 13/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension UIViewController {
    
    // function to show alert controller
    func showAlertController(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        alertController.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Hide the keyboard when tapped on the view
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // handele if the device has no camera
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera.",preferredStyle: .alert)
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
        
        let alert = UIAlertController(title: "MyDresser", message: "Please allow camera/ gallery access in phone settings", preferredStyle: UIAlertControllerStyle.alert)
        alert.view.tintColor = UIColor(red: 202/255, green: 67/255, blue: 108/255, alpha: 1)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction) in
        }));
        alert.addAction(UIAlertAction(title: "Open setting ", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }));
        self.present(alert, animated: true, completion: nil)
    }
    
    //Start spinner for View
    func startActivityIndicatorForView(spinner:UIActivityIndicatorView,view:UIView, style:UIActivityIndicatorViewStyle,x: CGFloat, y:CGFloat, width:CGFloat, height:CGFloat){
        
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  style
        spinner.frame = CGRect(x: x, y: y, width:width, height: height)
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    //Stop spinner
    func stopActivityIndicatorForView(spinner:UIActivityIndicatorView){
        spinner.stopAnimating()
    }
    
    //start spinner for Image
    func startActivityIndicatorForImage(spinner:UIActivityIndicatorView, newImage: UIImageView,style:UIActivityIndicatorViewStyle, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        //spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = style
        spinner.frame = CGRect(x: x, y: y, width: width, height: height)
        newImage.addSubview(spinner)
        spinner.startAnimating()
        
    }
    
    //stop spinner for Image
    func stopActivityIndicatorForImage(spinner:UIActivityIndicatorView){
        spinner.stopAnimating()
    }
    
    func setImageToTextField(textField: UITextField, image:UIImage, x:CGFloat, y: CGFloat,width: CGFloat, height: CGFloat){
        
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        imageView.contentMode = .center
        imageView.image = image
        textField.leftView = imageView
    }
    
    func createGradientLayer(view:UIView, gradientLayer: CAGradientLayer) {
        
        gradientLayer.frame = self.view.bounds
        let colorTop = UIColor(red: 231 / 255.0, green: 143.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 202.0 / 255.0, green: 67.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [colorTop,colorBottom]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func createGradientLayerForButton(view:UIView, gradientLayer: CAGradientLayer) {
        
        gradientLayer.frame = view.bounds
        let colorTop = UIColor(red: 231 / 255.0, green: 143.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 202.0 / 255.0, green: 67.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [colorTop,colorBottom]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
