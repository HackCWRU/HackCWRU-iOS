//
//  MentorRequestsTableViewController.swift
//  HackCWRU
//
//  Created by Jack on 4/9/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import UIKit

class MentorRequestsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var mentorRequests = [MentorRequest]()
    
    private var mentorRequestsSorted: [MentorRequest] {
        return mentorRequests.sorted { lhs, rhs in
            return lhs.opened > rhs.opened
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = UTCDate.stringFormat
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.allowsSelection = false
        
        addRefreshControl(selector: #selector(refresh))
        
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refresh()
    }
    
    @objc private func refresh() {
        mentorRequests = fetchMentorRequests()

        mentorRequests.forEach { mentorRequest in
            API.updateMentorRequestStatus(for: mentorRequest) { _ in
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
        
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func fetchMentorRequests() -> [MentorRequest] {
        let fetchRequest = MentorRequest.fetchRequest()
        let mentorRequests = (try? AppDelegate.moc.fetch(fetchRequest) as! [MentorRequest]) ?? []
        return mentorRequests
    }

    
    // MARK: - Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentorRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mentorRequest = mentorRequestsSorted[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentor-requests-cell", for: indexPath) as! AnnouncementCell
        
        if let opened = UTCDate(string: mentorRequest.opened)?.dateForCurrentTimezone {
            cell.titleLabel?.text = "\(opened.dayOfWeek()) \(dateFormatter.string(from: opened))"
        }

        cell.timeLabel?.text = mentorRequest.status.uppercased()
        cell.messageLabel?.text = mentorRequest.description
        
        return cell
    }
}
