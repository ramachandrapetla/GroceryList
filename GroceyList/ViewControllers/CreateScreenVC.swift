//
//  CreateScreenVC.swift
//  GroceyList
//
//  Created by Ramachandra petla on 9/29/22.
//

import UIKit

class CreateScreenVC: UIViewController {

    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createList(_ sender: Any) {
        if listName.text != "" {
            performSegue(withIdentifier: "create-to-list", sender: nil)
        } else {
            errorLabel.text = "List Name cannot be Empty"
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    //MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        //Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
        if segue.identifier == "create-to-list" {
            if let listVC = segue.destination as? ListTableViewController {
                if let name = listName.text {
                    CRUDActions.create(listName: name)
                    listVC.listName = name
                }
            }
        }
        
    }
    

}
