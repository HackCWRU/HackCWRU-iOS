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
        self.events = fetchEvents()
        self.tableView.reloadData()
        
        // Update core data objects with freshest data.
        API.getAllEvents() { events in
            self.events.update(to: events, saveBlock: { event in
                print("Save event \(event.id)")
            }, updateBlock: { from, to in
                print("Update event \(from.id)")
                from.name = to.name
                from.desc = to.startTime
                from.endTime = to.endTime
                from.location = to.location
                from.updatedAt = to.updatedAt
                from.isFavorite = to.isFavorite
            }, deleteBlock: { event in
                print("Delete event \(event.id)")
                AppDelegate.moc.delete(event)
            }, completion: {
                try! AppDelegate.moc.save()
            })
            
            // Refresh the local variable.
            self.events = self.fetchEvents()
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func fetchEvents() -> [Event] {
        let fetchRequest = Event.fetchRequest()
        let events = try? AppDelegate.moc.fetch(fetchRequest) as! [Event]
        return events ?? []
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
