//
//  ContactsTableViewController.swift
//  HackCWRU
//
//  Created by Jack on 4/12/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var contacts = [Contact]() {
        didSet {
            groupedContacts = contacts.grouped()
        }
    }
    
    private var groupedContacts = [String: [Contact]]()
    
    private var sortedGroups: [String] {
        return groupedContacts.keys.sorted(by: >)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        addRefreshControl(selector: #selector(refresh))
        refresh()
    }
    
    @objc func refresh() {
        API.getAllVisibleContacts { contacts, succeeded in
            if let contacts = contacts, succeeded {
                self.contacts = contacts
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedContacts.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts(for: section).count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedGroups[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = contact(for: indexPath).name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        contact(for: indexPath).call()
    }
    
    private func contacts(for section: Int) -> [Contact] {
        return groupedContacts[sortedGroups[section]] ?? []
    }
    
    private func contact(for indexPath: IndexPath) -> Contact {
        return contacts(for: indexPath.section)[indexPath.row]
    }

}
