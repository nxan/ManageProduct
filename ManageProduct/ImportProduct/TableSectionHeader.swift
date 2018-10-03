//
//  TableSectionHeader.swift
//  ManageProduct
//
//  Created by NXA on 9/23/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit

class TableSectionHeader: UITableViewCell {
    
    @IBOutlet var txtDate: UILabel!
    @IBOutlet var lblTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
