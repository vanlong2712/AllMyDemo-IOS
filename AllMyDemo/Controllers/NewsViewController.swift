//
//  ViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/15/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireRSSParser
import SwiftyJSON
import SVProgressHUD

class NewsViewController: UITableViewController {
    
    private let newsCell = "newsCell"
    private var items = [RSSItem]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let defaultUrl = "https://vnexpress.net/rss/tin-moi-nhat.rss"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.text = defaultUrl
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: newsCell)
        fetchData()
    }
    
    // MARK - Table View dataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCell, for: indexPath) as! NewsTableViewCell
        
        let item = items[indexPath.row]
        cell.titleLabel.text = item.title
        
        if let urlImage = item.imagesFromDescription?.first {
//            var splittedUrl = urlImage.components(separatedBy: "80_50")
//            let qualityImage = "200_150"
//            splittedUrl.append(splittedUrl[1])
//            splittedUrl[1] = qualityImage
//            let modifiedUrlImage = splittedUrl.joined(separator: "")
            let url = URL(string: urlImage)
            let data = try? Data(contentsOf: url!)
            let imageFromURL = UIImage(data: data!)
            cell.newsImageView.image = imageFromURL
        }
        
        if let itemDescription = item.itemDescription {
            let splittedItemDesCription = itemDescription.components(separatedBy: "</br>")
            if splittedItemDesCription.count > 1 {
                cell.descriptionLabel.text = splittedItemDesCription[1]
            }
        }
        
        if let pubDate = item.pubDate {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd MM yyyy HH:mm"
            
            cell.newsCreatedAtLabel.text = formatter.string(from: pubDate)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        SVProgressHUD.dismiss()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToWeb", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? WebViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let item = items[indexPath.row]
            destinationVC?.link = item.link!
        }
    }
    
    func fetchData() {
        if let text = searchBar.text {
            SVProgressHUD.show()
            Alamofire.request(text).responseRSS() { (response) -> Void in
                if response.result.isSuccess {
                    if let feed: RSSFeed = response.result.value {
                        self.items = feed.items
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension NewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
