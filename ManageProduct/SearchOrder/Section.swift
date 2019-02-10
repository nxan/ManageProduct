//
//  Section.swift
//  ManageProduct
//
//  Created by NXA on 2/4/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct Section {
    var key: String!
    var value: [String]!
    var expanded: Bool!
    var subtitle: String!
    
    init(key: String, value: [String], expanded: Bool, subtitle: String) {
        self.key = key
        self.value = value
        self.expanded = expanded
        self.subtitle = subtitle
    }
}
