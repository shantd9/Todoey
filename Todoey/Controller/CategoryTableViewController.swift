//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Shant Derounian on 12/24/19.
//  Copyright © 2019 Shant Derounian. All rights reserved.
//

import CoreData
import UIKit

class CategoryTableViewController: UITableViewController {
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var categories = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    //MARK: TableView DataSource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategory", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    //MARK: TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    //MARK: Data Manipulation methods
    
    //MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert =  UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    //MARK: Private methods
    
    func loadCategories(with request: NSFetchRequest<Category>! = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        }
        catch {
            print("Error \(error)")
        }

    }
    
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
}
