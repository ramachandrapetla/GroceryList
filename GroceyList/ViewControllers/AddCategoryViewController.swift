//
//  AddCategoryViewController.swift
//  GroceyList
//
//  Created by Vivek Kukkapalli on 10/25/22.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    var action = ""
    var oldCategory = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        actionBtn.setTitle(action + " Category", for: .normal)
        if action == "Update" {
            categoryInput.text = oldCategory
        }

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func addCategory(_ sender: Any) {
        if let category = categoryInput.text {
            if !category.isEmpty {
                if action == "Update" {
                    CRUDActions.updateCategory(oldWord: oldCategory, newWord: category)
                } else {
                    CRUDActions.createNewCategory(categoryName: category)
                }
                
                navigationController?.popViewController(animated: true)
            } else {
                errorLabel.text = "Categroy Name is Required"
            }
        } else {
            errorLabel.text = "Categroy Name is Required"
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
