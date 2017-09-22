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
    let categories = ["Select the category","other","formal","casual","ethnic"]
    var userId: String = ""
    var newUser = false
     var nextButton:UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select the category"
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        let nextButton = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: #selector(nextAction))
        self.navigationItem.setRightBarButtonItems([nextButton], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    // Number of rows in each component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // On each category click action
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryChosen.text = categories[row]
    }
    
    // Provide colour for the text in each row
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = categories[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    func nextAction(){
        
        if let category = categoryChosen.text {
            if category != "" && category != "Select the category" {
                print("category is \(category)")
                if chooseOrSuggest == "Choose my Attire"{
                    let previousOrNewTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"PreviousOrNewController") as! PreviousOrNewTableViewController
                    if let choosedCategory = DressCategory(rawValue: category) {
                        previousOrNewTVC.categoryOfDress = choosedCategory
                    }
                    previousOrNewTVC.userId = self.userId
                    previousOrNewTVC.newUser = self.newUser
                    self.navigationController?.pushViewController(previousOrNewTVC, animated: true)
                }
                else if chooseOrSuggest == "Suggest Me Something"{
                    let suggestVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"SuggestController") as! SuggestViewController
                    if let choosedCategory = DressCategory(rawValue: category){
                        suggestVC.categoryOfDress = choosedCategory
                    }
                    suggestVC.userId = self.userId
                    suggestVC.newUser = self.newUser
                    self.navigationController?.pushViewController(suggestVC, animated: true)
                }
            }
                // if the category is not selected alert the user asking him to select the category
            else{
                showAlertController(title:"Select Category", message: "Select the category of the attire before you proceed", actionTitle: "OK")
            }
        }
    }
}
