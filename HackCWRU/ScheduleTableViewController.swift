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
            eventsGroupAndSorted = events.groupAndSort(favoritesOnly)
        }
    }
    
    private var sectionDates: [Date] {
        return eventsGroupAndSorted.keys.sorted(by: <)
    }
    
    private var favoritesOnly: Bool {
        return favoritesControl.selectedSegmentIndex == 1
    }
    
    @IBOutlet weak var favoritesControl: UISegmentedControl!
    
    @IBAction func didChangeFavoritesFilter(_ sender: UISegmentedControl) {
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl(selector: #selector(refresh))
        hideExcessDividers()
        refresh()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    func refresh() {
        self.events = fetchEvents()
        self.tableView.reloadData()
        
        // Update core data objects with freshest data.
        API.getAllEvents() { events, success in
            
            if let events = events, success {
                self.events.update(to: events, saveBlock: { event in
                    print("Save event \(event.id)")
                }, updateBlock: { from, to in
                    print("Update event \(from.id)")
                    from.name = to.name
                    from.desc = to.desc
                    from.endTime = to.endTime
                    from.location = to.location
                    from.updatedAt = to.updatedAt
                }, deleteBlock: { event in
                    print("Delete event \(event.id)")
                    AppDelegate.moc.delete(event)
                }, completion: {
                    try! AppDelegate.moc.save()
                })
            }
            
            // Refresh the local variable.
            self.events = self.fetchEvents()
            
            self.populateEventMaps {
                self.refreshControl?.endRefreshing()
                self.reload()
            }
        }
    }
    
    func reload() {
        eventsGroupAndSorted = events.groupAndSort(favoritesOnly)
        tableView.reloadData()
    }
    
    func fetchEvents() -> [Event] {
        let fetchRequest = Event.fetchRequest()
        let events = (try? AppDelegate.moc.fetch(fetchRequest) as! [Event]) ?? []
        return events
    }
    
    func populateEventMaps(completion: @escaping () -> Void) {
        let locations = events.map { $0.location }
        
        API.getMaps(for: locations) { maps in
            for event in self.events {
                if let matchingMap = (maps ?? []).filter({ $0.location == event.location }).first {
                    event.map = matchingMap
                }
            }
            
            completion()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "event-cell", for: indexPath) as! EventCell
        let event = events(forSection: indexPath.section)[indexPath.row]
        
        cell.eventName?.text = event.name
        cell.eventTimeLocation?.text = event.timeSlot + " | " + (event.map?.name ?? event.location)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return events(forSection: section).first?.startDate.dayOfWeek() ?? sectionDateFormatter.string(from: sectionDates[section])
    }
    
    func events(forSection section: Int) -> [Event] {
        return eventsGroupAndSorted[sectionDates[section]] ?? []
    }
    
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "event-detail", sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "event-detail" {
            
            let event = events(forSection: indexPath.section)[indexPath.row]
            vc.event = event
            vc.delegate = self
        }
    }
    
}


extension ScheduleTableViewController: EventDetailViewControllerDelegate {
    
    func favoriteStatusDidChange() {
        reload()
    }
    
}

extension ScheduleTableViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            
            let event = events(forSection: indexPath.section)[indexPath.row]
            let eventViewController = storyboard?.instantiateViewController(withIdentifier: "event-detail-vc") as? EventDetailViewController
            eventViewController?.event = event
            eventViewController?.delegate = self
            return eventViewController
        }
        
        return nil
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
    
}
