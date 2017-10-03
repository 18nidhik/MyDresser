//
//  ImageViewExtention.swift
//  MyDresser
//
//  Created by Shrinidhi K on 25/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(URLString: String, onCompletion: @escaping () -> ()) {
           self.image = nil
        checkCacheForImage(URLString: URLString,callback: { (success) in
            if success {
                onCompletion()
                return
            } else {
                downloadImageFromStorage(URLString: URLString,callback: { (success) in
                    if success {
                        onCompletion()
                        return
                    } else {
                          onCompletion()
                        print("Could not download image")
                    }
                })
            }
        })
    }

    func checkCacheForImage(URLString: String, callback : (Bool) -> ()) {
        print("cache entered")
        var success = false
        
        if let cachedImage = imageCache.object(forKey: URLString as AnyObject) as? UIImage{
            print("image assigned by cache")
            self.image = cachedImage
            success = true
        }
        callback(success)
    }
    
    
    func downloadImageFromStorage(URLString: String, callback: @escaping (Bool) -> ()) {
        print("database entered")
        var success = false
        
        Storage.storage().reference(forURL: URLString).getData(maxSize: 3 * 1024 * 1024, completion: { (data, error) in
            //debugPrint("error : \(String(describing: error?.localizedDescription)) and Data : \(String(describing: data))")
            if error != nil {
                print(error ?? "request download error")
                return
            }
            
            if let data = data {
                let downloadedImage = UIImage(data: data)
                if let downloadedImage = downloadedImage {
                    imageCache.setObject(downloadedImage, forKey: URLString as AnyObject)
                    print("image set by database")
                    self.image = downloadedImage
                    success = true
                }
                callback(success)
            }
        })
    }
}
