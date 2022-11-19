//
//  HomeScreenVC.swift
//  GroceyList
//
//  Created by Ramachandra petla on 9/23/22.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var recentList: UITableView!
    
    
    var listData:[[String]] = []
    var selected = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recentList.delegate = self
        recentList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadListData()
    }
    
    func loadListData() {
//        listNames.removeAll()
        if let listArray = CRUDActions.getListNames() {
//            print(listArray.count)
//            for i in 0..<listArray.count {
//                listNames.append(listArray[i])
//            }
            listData = listArray
        } else {
            listData = []
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
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecentListTableViewCell
        cell.mainLabel.text = listData[indexPath.row][0]
        cell.secondaryInfoLabel.text = listData[indexPath.row][1]
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            CRUDActions.deleteList(name: listData[indexPath.row][0])
            listData.remove(at: indexPath.row)
            print("Index path value is: \(indexPath.row)::: count: \(listData.count)")
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = listData[indexPath.row][0]
        performSegue(withIdentifier: "home-list", sender: nil)
    }
}
