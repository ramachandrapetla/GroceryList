//
//  ListTableViewController.swift
//  GroceyList
//
//  Created by Ramachandra petla on 10/19/22.
//

import UIKit

class ListTableViewController: UITableViewController {

    var listItems:[[String]] = []
    var listName = ""
    var categorySet: [String] = []
    var checkedStatus = [[Bool]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = listName
        //loadListItems()
        
        //Creating Custon Back Button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(
            title: "<- Home",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Item",
            style: .plain,
            target: self,
            action: #selector(addItem))
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func addItem(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "listview-to-additem", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadListItems()
    }
    
    func loadListItems() {
        listItems.removeAll()
        categorySet.removeAll()
        checkedStatus.removeAll()
        print("I apperead again.. Voila!!")
        if let ItemsArray = CRUDActions.getListItems(listName: listName) {
            var set: Set<String> = []
            for i in 0..<ItemsArray.count {
                set.insert(ItemsArray[i].category)
            }
            categorySet = Array(set)
            categorySet.sort()
            print("categories: \(categorySet)")
            
            for category in categorySet {
                var categorized: [String] = []
                var checkImg: [Bool] = []
                for j in 0..<ItemsArray.count {
                    if ItemsArray[j].category == category {
                        categorized.append(ItemsArray[j].name)
                        checkImg.append(ItemsArray[j].checked)
                    }
                }
                listItems.append(categorized)
                checkedStatus.append(checkImg)
            }
        }
        print("data : \(listItems)")
        print("Checked Status: \(checkedStatus)")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categorySet.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categorySet[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list-item", for: indexPath) as! ListTableViewCell

        //cell.textLabel?.text = listItems[indexPath.row].name
        cell.listItemName.text = listItems[indexPath.section][indexPath.row]
        if checkedStatus[indexPath.section][indexPath.row] {
            cell.checkMarkImage.image = UIImage(named: "checked")
        } else {
            cell.checkMarkImage.image = UIImage(named: "unchecked")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checkItem:Bool = !checkedStatus[indexPath.section][indexPath.row]
        let itemName:String = listItems[indexPath.section][indexPath.row]
        CRUDActions.updateItemStatus(listName: listName, itemName: itemName, checkItem: checkItem)
        loadListItems()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        //Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
        print("Preparing seque1")
        if segue.identifier == "listview-to-additem" {
            print("Preparing seque2")
            if let addItemVC = segue.destination as? AddItemViewController {
                addItemVC.listName = listName
            }
        }
        
    }

}
