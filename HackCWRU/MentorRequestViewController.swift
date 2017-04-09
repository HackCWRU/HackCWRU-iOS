//
//  MentorRequestViewController.swift
//  HackCWRU
//
//  Created by Jack on 4/9/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import UIKit

class MentorRequestViewController: UIViewController {
    
    @IBOutlet weak var menteeNameTextField: UITextField!
    @IBOutlet weak var topicsTextField: UITextField!
    @IBOutlet weak var locationDescriptionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var submitMentorRequestButton: UIBarButtonItem!
    
    private var canSubmitMentorRequest: Bool {
        guard let menteeName = menteeNameTextField.text else { return false }
        guard let topics = topicsTextField.text else { return false }
        guard let location = locationDescriptionTextField.text else { return false }
        
        return menteeName.characters.count > 0 && topics.characters.count > 0 && location.characters.count > 0
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        submitMentorRequestButton.isEnabled = canSubmitMentorRequest
    }
    
    @IBAction func submitMentorRequest(_ sender: UIBarButtonItem) {
        guard let menteeName = menteeNameTextField.text else { return }
        guard let topics = topicsTextField.text else { return }
        guard let location = locationDescriptionTextField.text else { return }
        
        HackCWRUDefaults.lastSubmittedMenteeName = menteeName
        
        self.cancelButton.isEnabled = false
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.color = .gray
        navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicator), animated: false)
        activityIndicator.startAnimating()
        
        API.submitMentorRequest(menteeName: menteeName, topics: topics,
                                locationDescription: location) { mentorRequest, succeeded in
            if succeeded {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.cancelButton.isEnabled = true
                    self.navigationItem.rightBarButtonItem = sender
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitMentorRequestButton.isEnabled = false
        
        if let menteeName = HackCWRUDefaults.lastSubmittedMenteeName {
            menteeNameTextField.text = menteeName
            topicsTextField.becomeFirstResponder()
        } else {
            menteeNameTextField.becomeFirstResponder()
        }
    }
    
}
