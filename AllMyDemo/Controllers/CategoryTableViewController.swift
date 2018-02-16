//
//  CategoryTableViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/14/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        loadCategories()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    // MARK: - Table View data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let colour = UIColor(hexString: categories[indexPath.row].bgColor) {
            cell.backgroundColor = colour
            cell.textLabel?.text = categories[indexPath.row].name
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
        }
        return cell
    }
    
    // MARK: - Table View delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemToDo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ItemTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC?.selectedCategory = categories[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var tempTextField = UITextField()
        let alert = UIAlertController(title: "ADD NEW CATEGORY", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let text = tempTextField.text
            if text != "" {
                let newCategory = Category(context: self.context)
                newCategory.name = text
                newCategory.dateCreated = Date()
                newCategory.bgColor = UIColor.randomFlat().hexValue()
                self.categories.append(newCategory)
                self.saveCategories()
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add New Category"
            tempTextField = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Cannot save categories, \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Cannot fetch categories, \(error)")
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        context.delete(category)
        tableView.reloadData()
        categories.remove(at: indexPath.row)
        saveCategories()
    }
}
