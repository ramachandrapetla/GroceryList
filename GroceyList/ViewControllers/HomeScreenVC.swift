//
//  HomeScreenVC.swift
//  GroceyList
//
//  Created by Ramachandra petla on 9/23/22.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var recentList: UITableView!
    
    
    var listNames:[String] = ["Kitchen", "New Year Party", "Christams Party", "Kitchen", "New Year Party", "Christams Party", "Kitchen", "New Year Party",]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recentList.delegate = self
        recentList.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func createNewList(_ sender: Any) {
        performSegue(withIdentifier: "createNewList", sender: self)
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
            listNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I got a tap!!")
    }
}
