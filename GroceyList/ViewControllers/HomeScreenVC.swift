//
//  HomeScreenVC.swift
//  GroceyList
//
//  Created by Ramachandra petla on 9/23/22.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var recentList: UITableView!
    
    
    var listNames:[String] = []
    var selected = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadListData()
        recentList.delegate = self
        recentList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadListData()
    }
    
    func loadListData() {
        listNames.removeAll()
        print("I apperead again.. Voila!!")
        if let listArray = CRUDActions.getListNames() {
            print(listArray.count)
            for i in 0..<listArray.count {
                listNames.append(listArray[i])
            }
        }
        recentList.reloadData()
    }

    @IBAction func createNewList(_ sender: Any) {
        performSegue(withIdentifier: "createNewList", sender: self)
    }
    
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        //Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
        if segue.identifier == "home-list" {
            if let listVC = segue.destination as? ListTableViewController {
                listVC.listName = selected
            }
        }
        
    }
    

}

extension HomeScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecentListTableViewCell
        cell.mainLabel.text = listNames[indexPath.row]
        cell.secondaryInfoLabel.text = "12 items"
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            CRUDActions.deleteList(name: listNames[indexPath.row])
            listNames.remove(at: indexPath.row)
            print("Index path value is: \(indexPath.row)::: count: \(listNames.count)")
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = listNames[indexPath.row]
        performSegue(withIdentifier: "home-list", sender: nil)
    }
}
