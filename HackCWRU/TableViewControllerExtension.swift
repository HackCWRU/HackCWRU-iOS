//
//  Refreshable.swift
//  HackCWRU
//
//  Created by Jack on 1/6/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import UIKit

extension UITableViewController {
    
    func addRefreshControl(selector: Selector) {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: selector, for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    func hideExcessDividers() {
        tableView.tableFooterView = UIView()
    }
        
}
