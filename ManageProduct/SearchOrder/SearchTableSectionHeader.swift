//
//  SearchTableSectionHeader.swift
//  ManageProduct
//
//  Created by NXA on 2/10/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class SearchTableSectionHeader: UITableViewCell {
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblUnit: UILabel!
    @IBOutlet var lblWeight: UILabel!
    @IBOutlet var lblMoney: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
