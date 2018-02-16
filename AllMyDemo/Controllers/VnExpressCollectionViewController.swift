//
//  VnExpressCollectionViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/16/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireRSSParser
import SVProgressHUD

private let reuseIdentifier = "Cell"

class VnExpressCollectionViewController: UICollectionViewController {
     private let vnexpressContentCell = "vnexpressContentCell"
    private var items = [RSSItem]() {
        didSet {
            collectionView?.reloadData()
            collectionView?.layoutIfNeeded()
        }
    }
    var link: String? {
        didSet {
            fetchData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(UINib(nibName: "VNExpressContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: vnexpressContentCell)
        print("viewDidLoad")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vnexpressContentCell, for: indexPath) as! VNExpressContentCollectionViewCell
        let item = items[indexPath.row]
        print("here")
        cell.vnexpressTitleLabel.text = item.title
        
        if let urlImage = item.imagesFromDescription?.first {
            let url = URL(string: urlImage)
            let data = try? Data(contentsOf: url!)
            let imageFromURL = UIImage(data: data!)
            cell.vnexpressContentImageView.image = imageFromURL
        }
        
        if let pubDate = item.pubDate {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd MM yyyy HH:mm"
            
            cell.vnexpressDateLabel.text = formatter.string(from: pubDate)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        SVProgressHUD.dismiss()
    }
    
    
    func fetchData() {
        if let text = link {
            SVProgressHUD.show()
            Alamofire.request(text).responseRSS() { (response) -> Void in
                if response.result.isSuccess {
                    if let feed: RSSFeed = response.result.value {
                        self.items = feed.items
                    }
                }
            }
        }
    }
}
