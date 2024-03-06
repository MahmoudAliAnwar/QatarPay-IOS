//
//  LoyaltyCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/24/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class LoyaltyCardViewController: MainController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameOnCardLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    var card: Loyalty!
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

extension LoyaltyCardViewController {
    
    func setupView() {
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        
        self.imagesCollectionView.registerNib(LibCardImageCollectionViewCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
        
        if let frontImgUrl = card.frontSideImageLocation {
            frontImgUrl.getImageFromURLString { (status, image) in
                if status,
                   let img = image {
                    self.images.append(img)
                    self.imagesCollectionView.reloadData()
                }
            }
        }
        
        if let backImgUrl = card.backSideImageLocation {
            backImgUrl.getImageFromURLString { (status, image) in
                if status,
                   let img = image {
                    self.images.append(img)
                    self.imagesCollectionView.reloadData()
                }
            }
        }
        
        self.nameLabel.text = self.card.name ?? ""
        self.nameOnCardLabel.text = self.card.cardName ?? ""
        self.numberLabel.text = self.card.number ?? ""
        
        if let dateString = self.card.expiryDate,
           let date = dateString.server2StringToDate() {
            let finalDate = date.formatDate(libraryFieldsDateFormat)
            self.validityLabel.text = finalDate
        }
        
        if let brandString = self.card.brand, brandString.isNotEmpty {
            self.brandLabel.text = brandString
        }
        
        if let reminderString = self.card.reminderType,
               let reminderObj = ExpiryReminder.getObjectByNumber(reminderString) {
            self.reminderLabel.text = reminderObj.rawValue
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension LoyaltyCardViewController {

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension LoyaltyCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(LibCardImageCollectionViewCell.self, for: indexPath)
        
        let image = self.images[indexPath.row]
        cell.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing
        
        let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells)
        return CGSize(width: (cellWidth * 0.9), height: collectionView.height)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension LoyaltyCardViewController {
    
}
