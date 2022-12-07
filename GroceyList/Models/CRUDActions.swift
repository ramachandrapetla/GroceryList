//
//  CRUDActions.swift
//  GroceyList
//
//  Created by Ramachandra petla on 10/20/22.
//

import UIKit
import CoreData

class CRUDActions: NSObject {
    static func loadInitialData() {
        if let URL = Bundle.main.url(forResource: "Categories", withExtension: "plist") {
            if let categoryArray = NSArray(contentsOf: URL) as? [String] {
                for category in categoryArray {
                    createNewCategory(categoryName: category)
                }
            }
        }
    }
    
    static func updateTimestamp(listName: String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to update
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
            fetchRequest.predicate = NSPredicate(format: "listName = %@", listName)
            
            do{
                //Fetch the record to update
                let test = try managedContext.fetch(fetchRequest)

                //Update the record
                let objectToUpdate = test[0] as! NSManagedObject
                objectToUpdate.setValue(NSDate(), forKey: "timestamp")
                do{
                    //Save the managed object context
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Could not update the record! \(error), \(error.userInfo)")
                }
            }
            catch let error as NSError {
                print("Could not find the record to update! \(error), \(error.userInfo)")
            }
        }
    }
    
    static func create(listName:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            //Create a new empty record.
            let listEntity = NSEntityDescription.entity(forEntityName: "List", in: managedContext)!
            //Fill the new record with values
            let listMO = NSManagedObject(entity: listEntity, insertInto: managedContext)
            let timestamp = NSDate()
            listMO.setValue(listName, forKeyPath: "listName")
            listMO.setValue(timestamp, forKey: "timestamp")
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
            listMO.setValue(false, forKeyPath: "checked")
            do {
                //Save the managed object context
                print("Added new item to list")
                try managedContext.save()
                updateTimestamp(listName: listName)
            } catch let error as NSError {
                print("Could not add the new item! \(error), \(error.userInfo)")
            }
        }
    }
    
    static func getListNames() -> [[String]]? {
        //Get the managed context context from AppDelegate
        print("getListNames:: I was Called")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity (SELECT * FROM)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
            
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "timestamp", ascending: false)]
            do {
                //Execute the fetch request
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                    var listData = [[String]]()
                    for i in 0 ..< result.count {
                        let record = result[i] as! NSManagedObject
                        let name = record.value(forKey: "listName") as! String
                        let timestamp = record.value(forKey: "timestamp") as! Date
                        let df = DateFormatter()
                        df.dateFormat = "MMM d, yyyy"
                        let l = [name, df.string(from: timestamp)]
                        print("Time stamp: \(df.string(from: timestamp))")
                        listData.append(l)
                    }
                    print("Total lists available are : \(listData.count)")
                    return listData
                }
            } catch let error as NSError {
                print("Could not fetch the record! \(error), \(error.userInfo)")
            }
        }
        return nil
    }
    
    static func getListItems(listName:String) -> [ListItem]? {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            //Prepare the request of type NSFetchRequest  for the entity (SELECT * FROM)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
            fetchRequest.predicate = NSPredicate(format: "listName = %@", listName)
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "categoryName", ascending: false)]
            do {
                //Execute the fetch request
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                    var listItems = [ListItem]()
                    for i in 0 ..< result.count {
                        let record = result[i] as! NSManagedObject
                        let name = record.value(forKey: "itemName") as! String
                        let category = record.value(forKey: "categoryName") as! String
                        let checked = record.value(forKey: "checked") as! Bool
                        listItems.append(ListItem(name: name, category: category, checked: checked))
                    }
                    return listItems
                }
            } catch let error as NSError {
                print("Could not fetch the record! \(error), \(error.userInfo)")
            }
        }
        return nil
    }
    
    //update item status
    static func updateItemStatus(listName:String, itemName:String, checkItem:Bool) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to update
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
            fetchRequest.predicate = NSPredicate(format: "listName = %@ AND itemName = %@", listName, itemName)
            
            do{
                //Fetch the record to update
                let test = try managedContext.fetch(fetchRequest)

                //Update the record
                let objectToUpdate = test[0] as! NSManagedObject
                objectToUpdate.setValue(checkItem, forKey: "checked")
                do{
                    //Save the managed object context
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Could not update the record! \(error), \(error.userInfo)")
                }
            }
            catch let error as NSError {
                print("Could not find the record to update! \(error), \(error.userInfo)")
            }
        }
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
                        updateTimestamp(listName: listName)
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
    
    //Create new category
    static func createNewCategory(categoryName:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            //Create a new empty record.
            let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
            //Fill the new record with values
            let categoryMO = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
            categoryMO.setValue(categoryName, forKeyPath: "categoryName")
            do {
                //Save the managed object context
                print("Created a new Category")
                try managedContext.save()
            } catch let error as NSError {
                print("Could not create the new categroy! \(error), \(error.userInfo)")
            }
        }
    }
    
    static func getCategoryNames() -> [String]? {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity (SELECT * FROM)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "categoryName", ascending: false)]
            
            do {
                //Execute the fetch request
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                    var listNames = [String]()
                    for i in 0 ..< result.count {
                        let record = result[i] as! NSManagedObject
                        let name = record.value(forKey: "categoryName") as! String
                        listNames.append(name)
                    }
                    return listNames
                }
            } catch let error as NSError {
                print("Could not fetch the record! \(error), \(error.userInfo)")
            }
        }
        return nil
    }
    
    //Delete Categroy
    static func deleteCategory(categoryName: String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to delete
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            fetchRequest.predicate = NSPredicate(format: "categoryName = %@", categoryName)
            
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
    
    static func updateCategory(oldWord:String, newWord:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to update
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            fetchRequest.predicate = NSPredicate(format: "categoryName = %@", oldWord)
            
            do{
                //Fetch the record to update
                let test = try managedContext.fetch(fetchRequest)
                //Update the record
                let objectToUpdate = test[0] as! NSManagedObject
                objectToUpdate.setValue(newWord, forKey: "categoryName")
                do{
                    //Save the managed object context
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Could not update the record! \(error), \(error.userInfo)")
                }
            }
            catch let error as NSError {
                print("Could not find the record to update! \(error), \(error.userInfo)")
            }
        }
    }
}
