//
//  EventDetailViewController.swift
//  HackCWRU
//
//  Created by Jack on 1/4/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import UIKit

protocol EventDetailViewControllerDelegate {
    func favoriteStatusDidChange()
}

class EventDetailViewController: UITableViewController {
    
    var event: Event!
    var delegate: EventDetailViewControllerDelegate!
    
    
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    
    @IBAction func favorited(_ sender: UIBarButtonItem) {
        event.isFavorite = !event.isFavorite
        delegate.favoriteStatusDidChange()
        try! event.managedObjectContext?.save()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(event.name)
        print(event.isFavorite)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
