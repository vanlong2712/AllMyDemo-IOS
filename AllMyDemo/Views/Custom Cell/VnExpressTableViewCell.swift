//
//  VnExpressTableViewCell.swift
//  AllMyDemo
//
//  Created by Long on 2/16/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit

class VnExpressTableViewCell: UITableViewCell {

    @IBOutlet weak var VNEXImageView: UIImageView!
    
    @IBOutlet weak var VNEXTitleLabel: UILabel!
    @IBOutlet weak var VNEXDateCreateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
