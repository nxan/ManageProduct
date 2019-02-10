//
//  ExpendableHeaderView.swift
//  ManageProduct
//
//  Created by NXA on 2/4/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderView)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderView)))
    }
    
    @objc func selectHeaderView(gesture: UITapGestureRecognizer) {
        let cell = gesture.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func customInit(title: String, subtitle: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.lblTitle.text = title
        self.lblSubtitle.text = subtitle
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblTitle?.textColor = UIColor.white
        self.lblSubtitle?.textColor = UIColor.white
        self.lblSubtitle?.alpha = 1
        self.contentView.backgroundColor = UIColor(red: 36/255, green: 125/255, blue: 221/255, alpha: 1)
    }
}
