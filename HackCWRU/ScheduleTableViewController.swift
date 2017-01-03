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
    
    private var eventsGroupAndSorted = [Date: [Event]]()
    
    private lazy var sectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private var events = [Event]() {
        didSet {
            eventsGroupAndSorted = events.groupAndSort()
        }
    }
    
    private var sectionDates: [Date] {
        return eventsGroupAndSorted.keys.sorted(by: <)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        refresh()
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    func refresh() {
        API.getAllEvents() { events in
            self.events = events
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDates.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events(forSection: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event-cell", for: indexPath)
        let event = events(forSection: indexPath.section)[indexPath.row]
        
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.timeSlot + " | " + event.location

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionDateFormatter.string(from: sectionDates[section])
    }
    
    func events(forSection section: Int) -> [Event] {
        return eventsGroupAndSorted[sectionDates[section]] ?? []
    }
}
