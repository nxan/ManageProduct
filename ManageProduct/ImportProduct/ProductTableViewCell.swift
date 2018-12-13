//
//  ProductTableViewCell.swift
//  ManageProduct
//
//  Created by NXA on 9/19/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    var sectionIndex:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
