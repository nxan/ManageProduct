//
//  SearchResultTableViewCell.swift
//  ManageProduct
//
//  Created by NXA on 2/10/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet var textDateLabel: UILabel!
    @IBOutlet var textProductLabel: UILabel!
    @IBOutlet var textUnitLabel: UILabel!
    @IBOutlet var textWeightLabel: UILabel!
    @IBOutlet var textMoneyLabel: UILabel!
    @IBOutlet weak var imgSuccess: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
