//
//  VNExpressViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/15/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit

class VNExpressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var VnExpressContainerView: UIView!
    
    private let VNExpressCell = "VNExpressCell"
    
    private let nameOfCategories: [String] = ["Trang Chủ", "Thời sự", "Thế giới", "Kinh Doanh", "Start Up", "Giải Trí", "Thể Thao"]
    private let RSSUrls: [String] = ["https://vnexpress.net/rss/tin-moi-nhat.rss", "https://vnexpress.net/rss/thoi-su.rss", "https://vnexpress.net/rss/the-gioi.rss", "https://vnexpress.net/rss/kinh-doanh.rss", "https://vnexpress.net/rss/startup.rss", "https://vnexpress.net/rss/giai-tri.rss", "https://vnexpress.net/rss/the-thao.rss"]
    
    private var selectedIndexPath: IndexPath? {
        didSet {
//            print("selectedIndexPath", selectedIndexPath)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "VNEXPRESSCONTENT") as! VnExpressContentViewController
            vc.link = RSSUrls[(selectedIndexPath?.row)!]
        }
    }

    @IBOutlet weak var vnexpressCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        vnexpressCollectionView.delegate = self
        vnexpressCollectionView.dataSource = self
        vnexpressCollectionView.register(UINib(nibName: "VNExpressCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: VNExpressCell)
    }
    
    // MARK: - Collection View Datasource
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameOfCategories.count
     }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vnexpressCollectionView.dequeueReusableCell(withReuseIdentifier: VNExpressCell, for: indexPath) as! VNExpressCollectionViewCell
        cell.vnexpressCategoryLabel.text = nameOfCategories[indexPath.row]
        let colour = UIColor(hexString: "28AAC0")
        cell.vnexpressCategoryLabel.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: cell.frame.height - 1, width: cell.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor // background color
        if selectedIndexPath == nil {
            selectedIndexPath = indexPath
        } else if selectedIndexPath == indexPath {
            cell.borderBottomView.isHidden = false
        } else {
            cell.borderBottomView.isHidden = true
        }
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    // MARK: - Collection View delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vnexpressCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        selectedIndexPath = indexPath
        vnexpressCollectionView.reloadData()
    }
}
