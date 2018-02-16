//
//  RootTableViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/9/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {
    
    let nameOfApplications: [String] = ["Xylophone", "Dicee", "Weather", "Calculator", "True/False Question", "Todoey", "News RSS", "Vnexpress RSS"]
    let iconOfApplications: [String] = ["xylophone", "dicee", "sunny","xylophone", "dunno", "todo", "news", "news"]
    let segueIdentifier:[String] = ["goToXylophone", "goToDicee", "goToWeather", "goToCalculator", "goToQuestion", "goToToDo", "goToNews", "goToVnexpress"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyCustomCell", bundle: nil), forCellReuseIdentifier: "rootCell")
        tableView.rowHeight = UITableViewAutomaticDimension
//        messageTableView.estimatedRowHeight = 120.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        guard let navBarColour = UIColor(hexString: "1D9BF6") else {fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.init(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameOfApplications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rootCell", for: indexPath) as! RootTableViewCell
        
        cell.nameApplication.text = nameOfApplications[indexPath.row]
        cell.iconApplication.image = UIImage(named: iconOfApplications[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier[indexPath.row], sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

   
}
