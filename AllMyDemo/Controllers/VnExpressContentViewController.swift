//
//  VnExpressContentViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/16/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireRSSParser
import SVProgressHUD

class VnExpressContentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    private let vnexpressContentCell = "vnexpressContentCell"
    @IBOutlet weak var vnexpressContentCV: UICollectionView!
    private var items = [RSSItem]()
    var link: String? {
        didSet {
            fetchData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        vnexpressContentCV.register(UINib(nibName: "VNExpressContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: vnexpressContentCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vnexpressContentCV.dequeueReusableCell(withReuseIdentifier: vnexpressContentCell, for: indexPath) as! VNExpressContentCollectionViewCell
        let item = items[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        SVProgressHUD.dismiss()
    }
    
    func fetchData() {
        SVProgressHUD.show()
        if let text = link {
            Alamofire.request(text).responseRSS() { (response) -> Void in
                if response.result.isSuccess {
                    if let feed: RSSFeed = response.result.value {
                        self.items = feed.items
                        self.vnexpressContentCV.reloadData()
                    }
                }
            }
        }
    }
    
}
