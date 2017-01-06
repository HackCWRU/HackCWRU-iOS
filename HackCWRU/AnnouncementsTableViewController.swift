//
//  AnnouncementsTableViewController.swift
//  HackCWRU
//
//  Created by Jack on 1/6/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import UIKit

class AnnouncementsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var sortedAnnouncements = [Announcement]()
    
    private var announcements = [Announcement]() {
        didSet {
            sortedAnnouncements = announcements.sorted { lhs, rhs in
                // Sort newest to oldest.
                lhs.updatedAt > rhs.updatedAt
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addRefreshControl()
        refresh()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    func refresh() {
        self.announcements = fetchAnnouncements()
        self.tableView.reloadData()
        
        // Update core data objects with freshest data.
        API.getAllAnnouncements() { announcements, success in
            
            if let announcements = announcements, success {
                self.announcements.update(to: announcements, saveBlock: { announcement in
                    print("Save event \(announcement.id)")
                }, updateBlock: { from, to in
                    print("Update event \(from.id)")
                    from.title = to.title
                    from.message = to.message
                }, deleteBlock: { announcement in
                    print("Delete event \(announcement.id)")
                    AppDelegate.moc.delete(announcement)
                }, completion: {
                    try! AppDelegate.moc.save()
                })
            }
            
            // Refresh the local variable.
            self.announcements = self.fetchAnnouncements()
            self.refreshControl?.endRefreshing()
            self.reload()
        }
    }
    
    func reload() {
        sortedAnnouncements = announcements.sorted { lhs, rhs in
            // Sort newest to oldest.
            lhs.updatedAt > rhs.updatedAt
        }
        tableView.reloadData()
    }
    
    func fetchAnnouncements() -> [Announcement] {
        let fetchRequest = Announcement.fetchRequest()
        let events = try? AppDelegate.moc.fetch(fetchRequest) as! [Announcement]
        return events ?? []
    }
    
    
    // MARK: - Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedAnnouncements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "announcements-cell", for: indexPath) as! AnnouncementCell
        let announcement = sortedAnnouncements[indexPath.row]
        
        cell.titleLabel?.text = announcement.title
        cell.messageLabel?.text = announcement.message
        cell.timeLabel?.text = announcement.sentTimestamp
        
        return cell
    }
    
}
