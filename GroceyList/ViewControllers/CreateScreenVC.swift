//
//  CreateScreenVC.swift
//  GroceyList
//
//  Created by Ramachandra petla on 9/29/22.
//

import UIKit

class CreateScreenVC: UIViewController {

    @IBOutlet weak var listName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createList(_ sender: Any) {
        performSegue(withIdentifier: "create-to-list", sender: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
