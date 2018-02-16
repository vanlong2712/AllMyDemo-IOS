//
//  ItemTableViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/14/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class ItemTableViewController: SwipeTableViewController {

    var items = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.bgColor else {fatalError("selectedCategory does not exist")}
        
        updateNavbar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavbar(withHexCode: "1D9BF6")
    }
    
    // MARK: - NavBar setup method
    func updateNavbar(withHexCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.init(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let todoItem: Item = items[indexPath.row]
        cell.textLabel?.text = todoItem.name
        cell.accessoryType = todoItem.isDone ? .checkmark : .none
        if let colour = UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items.count)) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
            cell.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
        }
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        saveItems()
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var tempTextField = UITextField()
        let alert = UIAlertController(title: "ADD NEW ITEM", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let text = tempTextField.text
            if text != "" {
                let item = Item(context: self.context)
                item.name = text
                item.dateCreated = Date()
                item.parentCategory = self.selectedCategory
                self.items.append(item)
                self.saveItems()
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add new item"
            tempTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Cannot save item, \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let parentPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentPredicate, additionalPredicate])
        } else {
            request.predicate = parentPredicate
        }
        do {
            items = try context.fetch(request)
        } catch {
            print("Cannot fetch items, \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        let item = items[indexPath.row]
        context.delete(item)
        tableView.reloadData()
        items.remove(at: indexPath.row)
        saveItems()
    }
}

extension ItemTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchItemWithSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
              searchBar.resignFirstResponder()
            }
        } else {
            fetchItemWithSearch()
        }
    }
    
    func fetchItemWithSearch() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
}
