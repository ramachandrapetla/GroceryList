//
//  CRUDActions.swift
//  GroceyList
//
//  Created by Ramachandra petla on 10/20/22.
//

import UIKit
import CoreData

class CRUDActions: NSObject {
    static func create(listName:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            //Create a new empty record.
            let listEntity = NSEntityDescription.entity(forEntityName: "List", in: managedContext)!
            //Fill the new record with values
            let listMO = NSManagedObject(entity: listEntity, insertInto: managedContext)
            listMO.setValue(listName, forKeyPath: "listName")
            do {
                //Save the managed object context
                print("Created a new List")
                try managedContext.save()
            } catch let error as NSError {
                print("Could not create the new List! \(error), \(error.userInfo)")
            }
        }
    }
    
    static func addItemToList(listName:String, itemName:String, category:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            //Create a new empty record.
            print("Adding item:: listname: \(listName) & itemName: \(itemName) & category: \(category)")
            let listEntity = NSEntityDescription.entity(forEntityName: "Items", in: managedContext)!
            //Fill the new record with values
            let listMO = NSManagedObject(entity: listEntity, insertInto: managedContext)
            listMO.setValue(listName, forKeyPath: "listName")
            listMO.setValue(itemName, forKeyPath: "itemName")
            listMO.setValue(category, forKeyPath: "categoryName")
            do {
                //Save the managed object context
                print("Added new item to list")
                try managedContext.save()
            } catch let error as NSError {
                print("Could not add the new item! \(error), \(error.userInfo)")
            }
        }
    }
    
    static func getListNames() -> [String]? {
        //Get the managed context context from AppDelegate
        print("getListNames:: I was Called")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity (SELECT * FROM)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
            
            //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "word", ascending: false)]
            do {
                //Execute the fetch request
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                    var listNames = [String]()
                    for i in 0 ..< result.count {
                        let record = result[i] as! NSManagedObject
                        let name = record.value(forKey: "listName") as! String
                        listNames.append(name)
                    }
                    print("Total lists available are : \(listNames.count)")
                    return listNames
                }
            } catch let error as NSError {
                print("Could not fetch the record! \(error), \(error.userInfo)")
            }
        }
        return nil
    }
    
    static func getListItems(listName:String) -> [ListItem]? {
        //Get the managed context context from AppDelegate
        print("getListItems:: I was Called")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            print("Getting items for list: \(listName)")
            //Prepare the request of type NSFetchRequest  for the entity (SELECT * FROM)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
            fetchRequest.predicate = NSPredicate(format: "listName = %@", listName)
            //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "word", ascending: false)]
            do {
                //Execute the fetch request
                let result = try managedContext.fetch(fetchRequest)
                print(print("getListItems: Rows after fetch : \(result.count)"))
                if result.count > 0 {
                    var listItems = [ListItem]()
                    for i in 0 ..< result.count {
                        let record = result[i] as! NSManagedObject
                        let name = record.value(forKey: "itemName") as! String
                        let category = record.value(forKey: "categoryName") as! String
                        listItems.append(ListItem(name: name, category: category))
                    }
                    print("Total items available in list are : \(listItems.count)")
                    return listItems
                }
            } catch let error as NSError {
                print("Could not fetch the record! \(error), \(error.userInfo)")
            }
        }
        return nil
    }
    
    //Delete List
    static func deleteList(name:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to delete
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
            fetchRequest.predicate = NSPredicate(format: "listName = %@", name)
            
            do {
                //Fetch the record to delete
                let test = try managedContext.fetch(fetchRequest)
                
                //Delete the record
                let objectToDelete = test[0] as! NSManagedObject
                deleteListItem(listName: name, itemName: "")
                managedContext.delete(objectToDelete)
                
                do {
                    //Save the managed object context
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Could not delete the record! \(error), \(error.userInfo)")
                }
            }
            catch let error as NSError {
                print("Could not find the record to delete! \(error), \(error.userInfo)")
            }
        }
    }
    
    //Delete list item
    static func deleteListItem(listName:String, itemName:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to delete
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
            if itemName == "" {
                fetchRequest.predicate = NSPredicate(format: "listName = %@", listName)
            } else {
                fetchRequest.predicate = NSPredicate(format: "listName = %@ AND itemName = %@", listName, itemName)
            }
            
            do {
                //Fetch the record to delete
                let test = try managedContext.fetch(fetchRequest)
                
                //Delete the record
                if test.count > 0 {
                    let objectToDelete = test[0] as! NSManagedObject
                    managedContext.delete(objectToDelete)
                    
                    do {
                        //Save the managed object context
                        try managedContext.save()
                    }
                    catch let error as NSError {
                        print("Could not delete the record! \(error), \(error.userInfo)")
                    }
                }
            }
            catch let error as NSError {
                print("Could not find the record to delete! \(error), \(error.userInfo)")
            }
        }
    }
    //end of delete list item
    
}
