//
//  CategoryViewController.swift
//  MyDresser
//
//  Created by Shrinidhi K on 07/09/17.
//  Copyright © 2017 Shrinidhi K. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var categoryChosen: UILabel!
    var chooseOrSuggest:String = ""
    let categories = ["formal","casual","ethnic"]
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryChosen.text = categories[row]
    }
    

    @IBAction func goToNext(_ sender: Any) {
        if chooseOrSuggest == "Choose my Attire"{
            let previousOrNewTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"PreviousOrNewController") as! PreviousOrNewTableViewController
            if let category = categoryChosen.text{
                if let choosedCategory = DressCategory(rawValue: category) {
            previousOrNewTVC.categoryOfDress = choosedCategory
                }
            }
            previousOrNewTVC.userId = self.userId
            self.navigationController?.pushViewController(previousOrNewTVC, animated: true)
        }
        else if chooseOrSuggest == "Suggest Me Something"{
            let suggestVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"SuggestController") as! SuggestViewController
            suggestVC.categoryOfDress = DressCategory(rawValue: categoryChosen.text!)!
            suggestVC.userId = self.userId
            self.navigationController?.pushViewController(suggestVC, animated: true)
        }
        

    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
