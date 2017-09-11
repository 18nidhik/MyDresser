//
//  PreviousTableViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseDatabase


class PreviousTableViewController: UITableViewController {
    var categoryOfDress: DressCategory = .other
    var urlsOfTop :[NSURL] = []
    var urlsOfBottom :[NSURL] = []
    var databaseref : DatabaseReference?
    var databaseHandle :DatabaseHandle?


    override func viewDidLoad() {
        super.viewDidLoad()
        databaseref = Database.database().reference()

        detailsOfDresses = []
        keys = []
        databaseref?.child("dresses").observeSingleEvent(of: .value, with: {(snapshot) in
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
                    let topUrlString = values["top"] as! String
                    let topUrl = NSURL(string: topUrlString)
                    self.urlsOfTop.append(topUrl!)
                    let bottomUrlString = values["bottom"] as! String
                    let bottomUrl = NSURL(string: bottomUrlString)
                    self.urlsOfBottom.append(bottomUrl!)
                    
                }
            }
            for url in self.urlsOfTop{
                print(url)
            }
            self.tableView.reloadData()
        })

        
        
        
        
        print("hello")
        print(urlsOfTop.count)
        print(urlsOfBottom.count)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return urlsOfTop.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousCell", for: indexPath) as? PreviousTableViewCell else{
            fatalError("The dequeued cell is not an instance of ChooseOrSuggestTableViewCell.")
        }
        
                            let asset = PHAsset.fetchAssets(withALAssetURLs: [urlsOfTop[indexPath.row] as URL], options: nil)
                            guard let result = asset.firstObject else {
                                return cell
                            }
                            let imageManager = PHImageManager.default()
                            var imageData: Data? = nil
                            imageManager.requestImageData(for: result, options: nil, resultHandler: { (data, string, orientation, dict) in
                                imageData = data
                             cell.topPreviousImage.image = UIImage(data: imageData!)
                            })
                            let asset1 = PHAsset.fetchAssets(withALAssetURLs: [urlsOfBottom[indexPath.row] as URL], options: nil)
                            guard let result1 = asset1.firstObject else {
                                return cell
                            }
                            let imageManager1 = PHImageManager.default()
                            var imageData1: Data? = nil
                            imageManager1.requestImageData(for: result1, options: nil, resultHandler: { (data, string, orientation, dict) in
                                imageData1 = data
                             cell.bottomPreviousImage.image = UIImage(data: imageData1!)!
                            })
//            cell.buttonObj =
//            {
//                let newDressVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"NewDressController") as! NewDressViewController
//                self.navigationController?.pushViewController(newDressVC, animated: true)
//                
//             }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow;
       // print(indexPath?.row)
        let newDressVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"NewDressController") as! NewDressViewController
        newDressVC.categoryOfPreviousDress  = categoryOfDress
        newDressVC.topUrlOfPreviousDress = urlsOfTop[(indexPath?.row)!]
        newDressVC.bottomUrlOfPreviousDress = urlsOfBottom[(indexPath?.row)!]
        self.navigationController?.pushViewController(newDressVC, animated: true)
    }
}
//    func setImagesToTableView(){
//
//    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


