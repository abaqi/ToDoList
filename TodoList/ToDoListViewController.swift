//
//  ViewController.swift
//  TodoList
//
//  Created by MacBook Pro on 06/09/2019.
//  Copyright © 2019 abc. All rights reserved.
//

import UIKit
import CoreData //To use the Entity Item

class ToDoListViewController: UITableViewController  {
    
    var itemArray = [Item]()
    
    
    //Basically accessing AppDelegate as an object
    //pERSISTENcONTAINER == SQLite Object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard  //Tapping into SINGLETON static type UserDefault
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //done by dragging search bar line to yellow icon
//        searchBar.delegate = self
//        print(dataFilePath)
        
        loadItems()
        
//        If default plist exisits, pull that make that the array
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Swift ternary operator - setting 2 values accoridng to bool value
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add a checkmark
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        //deselect the checkmark
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //set iNDEX PROPERTY OF The selected item
        
        //Toggling done attribute with checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Delete selected item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        self.saveItems() //Commiting changes method
        
        //will keep cell from staying highlighted
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            //Using App Delegate as the object using UI Application shared
            //Object of Persistant DB so will take its context
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            //what will happen ones the user clicks the add button
            //self.itemArray.append(textField.text!)
            //Save this updated array to our user defaults
            //self.defaults.set(self.itemArray, forKey: "TodoListArray") //abandoning ship to stop using user defaults. use defaults for only small tidbits
            self.saveItems()
        
        }
        
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        //No longer using this after moving to coredata
//               let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Eroro encoding item array")
//        }
        do{
            try context.save() //Committing the unsaved changes to DB
        } catch {
            print("Error saving context \(error)")
        }

        
        self.tableView.reloadData()
    }
    //with request are external and iternal parameters
    //Item.fetchRequest is the default value used for initial loadItems call
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        
        //Replaced by CoreData SQLite
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//            itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Erorr decoding item array")
//            }
//    }
        
        //specify datatype adn Entity here here because
  //      let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request) //runs the GET request ^
        } catch {
            print("Erorr fetching Items \(error)")
        }
    }
}

//MARK: - Search Bar Methods
//Modularising the ToDo class
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //when the search bar is clicked, searchBar.text is going to be passed
        //into this method as an arg
        //The query becomes title CONTAINS 'yourText' - query language
        //There is a NSPredicateCheatsheet
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        //initializing sort Descriptors - sort using the title
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //Telling search bar to stop being first responder and drop keyboard
            //the guy who manages process Queue
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
