//
//  CategoryListTableViewController.swift
//  GroceyList
//
//  Created by Vivek Kukkapalli on 10/25/22.
//

import UIKit

class CategoryListTableViewController: UITableViewController {

    var data = [String]()
    var action = ""
    var rowSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categories"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(addCategory))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        while true {
            if let categoryList = CRUDActions.getCategoryNames() {
                data = categoryList
            } else {
                data = []
            }
            if data.count < 1 {
                CRUDActions.loadInitialData()
            } else {
                break
            }
        }
        tableView.reloadData()
    }

    @objc func addCategory(sender: UIBarButtonItem) {
        action = "Add"
        performSegue(withIdentifier: "categorylist-add", sender: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category-cell", for: indexPath)

        cell.textLabel?.text = data[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if data[indexPath.row] == "Other" {
            return .none
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            self.action = "Update"
            self.rowSelected = self.data[indexPath.row]
            self.performSegue(withIdentifier: "categorylist-add", sender: nil)
        }
        editAction.backgroundColor = UIColor.systemBlue


        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            CRUDActions.deleteCategory(categoryName: self.data[indexPath.row])
            self.loadData()
            
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

        return configuration
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        //Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
        if segue.identifier == "categorylist-add" {
            if let addVC = segue.destination as? AddCategoryViewController {
                addVC.action = action
                addVC.oldCategory = rowSelected
            }
        }
    }

}
