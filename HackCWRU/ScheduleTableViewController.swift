//
//  ScheduleTableViewController.swift
//  HackCWRU
//
//  Created by Jack on 1/3/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }
    
    private func refresh() {
        API.getAllEvents() { events in
            self.events = events
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event-cell", for: indexPath)
        let event = events[indexPath.row]
        let timeSlot = event.startTime + " - " + event.startTime
        
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = timeSlot + " | " + event.location

        return cell
    }
    

}
