//
//  LicenseDetailsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/24/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class IDLicenseDetailsViewController: MainController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!

    @IBOutlet weak var idTitleLabel: UILabel!
    
    @IBOutlet weak var nameOnCardLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var bloodPlaceTitleLabel: UILabel!
    @IBOutlet weak var bloodPlaceLabel: UILabel!
    @IBOutlet weak var issueTitleLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var validityTitleLabel: UILabel!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    var idCard: IDCard?
    var drivingLicense: DrivingLicense?
    
    var images = [UIImage]()

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

extension IDLicenseDetailsViewController {
    
    func setupView() {
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        
        self.imagesCollectionView.register(UINib(nibName: Cells.LibCardImageCollectionViewCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.LibCardImageCollectionViewCell.rawValue)
    }
    
    func localized() {
    }
    
    func setupData() {
        self.isIdentificationView(self.drivingLicense == nil)
        
        if let card = self.idCard {
            if let frontImgUrl = card.frontSideImageLocation {
                frontImgUrl.getImageFromURLString { (status, image) in
                    if status, let img = image {
                        self.images.append(img)
                        self.imagesCollectionView.reloadData()
                    }
                }
            }
            
            if let backImgUrl = card.backSideImageLocation {
                backImgUrl.getImageFromURLString { (status, image) in
                    if status, let img = image {
                        self.images.append(img)
                        self.imagesCollectionView.reloadData()
                    }
                }
            }
            
            self.nameOnCardLabel.text = card.name ?? ""
            self.nationalityLabel.text = card.nationality ?? ""
            self.bloodPlaceLabel.text = card.placeOfIssue ?? ""
            self.numberLabel.text = card.number ?? ""
            
            if let dateString = card.dateofBirth {
                let serverDate = dateString.server2StringToDate()
                if let date = serverDate {
                    let finalDate = date.formatDate(libraryFieldsDateFormat)
                    self.dateOfBirthLabel.text = finalDate
                }
            }
            
            if let dateString = card.dateofIssue {
                let serverDate = dateString.server2StringToDate()
                if let date = serverDate {
                    let finalDate = date.formatDate(libraryFieldsDateFormat)
                    self.issueLabel.text = finalDate
                }
            }
            
            if let dateString = card.dateofExpiry {
                let serverDate = dateString.server2StringToDate()
                if let date = serverDate {
                    let finalDate = date.formatDate(libraryFieldsDateFormat)
                    self.validityLabel.text = finalDate
                }
            }
            
            if let reminderString = card.reminderType {
                if let reminderObj = ExpiryReminder.getObjectByNumber(reminderString) {
                    self.reminderLabel.text = reminderObj.rawValue
                }
            }
            
        }else if let license = self.drivingLicense {
            
            if let frontImgUrl = license.frontSideImageLocation {
                frontImgUrl.getImageFromURLString { (status, image) in
                    if status, let img = image {
                        self.images.append(img)
                        self.imagesCollectionView.reloadData()
                    }
                }
            }
        
            if let backImgUrl = license.backSideImageLocation {
                backImgUrl.getImageFromURLString { (status, image) in
                    if status, let img = image {
                        self.images.append(img)
                        self.imagesCollectionView.reloadData()
                    }
                }
            }
            
            self.nameOnCardLabel.text = license.name ?? ""
            self.nationalityLabel.text = license.nationality ?? ""
            self.bloodPlaceLabel.text = license.bloodType ?? ""
            self.numberLabel.text = license.number ?? ""

            if let dateString = license.dateofBirth {
                let serverDate = dateString.server2StringToDate()
                if let date = serverDate {
                    let finalDate = date.formatDate(libraryFieldsDateFormat)
                    self.dateOfBirthLabel.text = finalDate
                }
            }
            
            if let dateString = license.firstIssueDate {
                let serverDate = dateString.server2StringToDate()
                if let date = serverDate {
                    let finalDate = date.formatDate(libraryFieldsDateFormat)
                    self.issueLabel.text = finalDate
                }
            }
            
            if let dateString = license.validity {
                let serverDate = dateString.server2StringToDate()
                if let date = serverDate {
                    let finalDate = date.formatDate(libraryFieldsDateFormat)
                    self.validityLabel.text = finalDate
                }
            }
            
            if let reminderString = license.reminderType {
                if let reminderObj = ExpiryReminder.getObjectByNumber(reminderString) {
                    self.reminderLabel.text = reminderObj.rawValue
                }
            }
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension IDLicenseDetailsViewController {

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension IDLicenseDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.LibCardImageCollectionViewCell.rawValue, for: indexPath) as! LibCardImageCollectionViewCell
        
        let image = self.images[indexPath.row]
        cell.image = image
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = self.view.frame.width
//        return .init(width: width, height: width / 2)
//    }
}

// MARK: - PRIVATE FUNCTIONS

extension IDLicenseDetailsViewController {
    
    private func isIdentificationView(_ status: Bool) {
        self.idTitleLabel.text = status ? "Identification" : "Driving License"
        self.bloodPlaceTitleLabel.text = status ? "Place of Issue" : "Blood Group"
        self.issueTitleLabel.text = status ? "Date of Issue" : "First Issue"
        self.validityTitleLabel.text = status ? "Date of Expiry" : "Validity"
    }
}
