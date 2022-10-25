//
//  AddCategoryViewController.swift
//  GroceyList
//
//  Created by Vivek Kukkapalli on 10/25/22.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var categoryInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func addCategory(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
