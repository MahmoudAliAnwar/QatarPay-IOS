//
//  PassportDetailsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/19/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PassportDetailsViewController: MainController {

    @IBOutlet weak var passportImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var codeOfIssueStateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var surNameENLabel: UILabel!
    @IBOutlet weak var surNameARLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var givenNamesENLabel: UILabel!
    @IBOutlet weak var givenNamesARLabel: UILabel!
    @IBOutlet weak var dateOfIssueLabel: UILabel!
    @IBOutlet weak var dateOfExpiryLabel: UILabel!
    @IBOutlet weak var placeOfIssueLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    var passport: Passport!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
}

extension PassportDetailsViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
        
        self.typeLabel.text = self.passport.type ?? ""
        self.numberLabel.text = self.passport.number ?? ""
        self.surNameENLabel.text = self.passport.surName ?? ""
        self.givenNamesENLabel.text = self.passport.givenName ?? ""
        self.placeOfIssueLabel.text = self.passport.placeOfIssue ?? ""
        
        if let dateString = self.passport.dateOfBirth {
            let serverDate = dateString.server2StringToDate()
            if let date = serverDate {
                let finalDate = date.formatDate(libraryFieldsDateFormat)
                self.dateOfBirthLabel.text = finalDate
            }
        }
        
        if let dateString = self.passport.dateOfIssue {
            let serverDate = dateString.server2StringToDate()
            if let date = serverDate {
                let finalDate = date.formatDate(libraryFieldsDateFormat)
                self.dateOfIssueLabel.text = finalDate
            }
        }
        
        if let dateString = self.passport.dateOfExpiry {
            let serverDate = dateString.server2StringToDate()
            if let date = serverDate {
                let finalDate = date.formatDate(libraryFieldsDateFormat)
                self.dateOfExpiryLabel.text = finalDate
            }
        }
        
        if let reminderString = self.passport.reminderType {
            if let reminderObj = ExpiryReminder.getObjectByNumber(reminderString) {
                self.reminderLabel.text = reminderObj.rawValue
            }
        }
        
        if let image = self.passport.imageLocation {
            image.getImageFromURLString { (status, image) in
                if status {
                    if let img = image {
                        self.passportImageView.image = img
                    }
                }
            }
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PassportDetailsViewController {

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension PassportDetailsViewController {
    
}
