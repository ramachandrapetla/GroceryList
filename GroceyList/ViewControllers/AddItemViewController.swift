//
//  AddItemViewController.swift
//  GroceyList
//
//  Created by Ramachandra petla on 10/24/22.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var category: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var categorySelected = "--"
    var categoryDataSource:[String] = []
    var listName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.category.delegate = self
        self.category.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let categories = CRUDActions.getCategoryNames() {
            categoryDataSource = categories
        }
        categorySelected = categoryDataSource[0]
    }

    @IBAction func addItem(_ sender: Any) {
        if let name = itemName.text {
            if name != "" {
                CRUDActions.addItemToList(listName: listName, itemName: name, category: categorySelected)
                self.navigationController?.popViewController(animated: true)
            } else {
                errorLabel.text = "Item Name cannot be empty"
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelected = categoryDataSource[row]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
