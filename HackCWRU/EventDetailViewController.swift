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
    
    override var previewActionItems: [UIPreviewActionItem] {
        return [event.favoritePreviewAction]
    }
    
    
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    
    @IBAction func favorited(_ sender: UIBarButtonItem) {
        event.isFavorite = !event.isFavorite
        highlightFavoriteButton()
        delegate.favoriteStatusDidChange()
        try! event.managedObjectContext?.save()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highlightFavoriteButton()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func highlightFavoriteButton() {
        let imageName = event.isFavorite ? "navbar-favorite-filled" : "navbar-favorite"
        guard let image = UIImage(named: imageName + ".png") else { return }
        favoriteBarButton.image = image
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "event-name-cell", for: indexPath) as! EventNameCell
            cell.nameLabel.text = event.name
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "event-desc-cell", for: indexPath) as! EventDescriptionCell
            cell.descriptionLabel.text = event.desc
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "event-loc-cell", for: indexPath) as! EventTimeLocationCell
        cell.locationLabel.text = event.location
        cell.timeLabel.text = event.weekdaySymbol  + ", " + event.timeSlot
        cell.isUserInteractionEnabled = false
        return cell
    }

}
