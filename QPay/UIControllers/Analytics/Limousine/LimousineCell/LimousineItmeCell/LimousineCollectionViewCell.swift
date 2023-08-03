//
//  LimousineCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/12/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Cosmos

protocol LimousineCollectionViewCellDelegate: AnyObject {
    func didTapAddToMyLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails)
    func didTapRemoveToMyLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails)
    func didTapCallLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails)
    func didTapOpenMapLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails)
    func didTapOpenEmailLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails)
    func didTapOpenWebsiteLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails)
}

class LimousineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var officeLabel: UILabel!
    
    @IBOutlet weak var workTimeLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var rateCosmosView: CosmosView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    weak var delegate: LimousineCollectionViewCellDelegate?
    
    var isDirectory: Bool = true {
        willSet {
            self.isDirectoryLimousine(newValue)
        }
    }
    
    var object: OjraDetails! {
        willSet {
            guard let data = newValue else { return }
            self.nameLabel.text = data._ojraAccountInfoList.first?._companyName
//            self.nameLabel.sizeToFit()
//            if let str = data._ojraAccountInfoList.first {
//                let attributedString  = NSAttributedString(string: str._companyName)
//                self.nameLabel.attributedText       = attributedString
//                self.nameLabel.sizeThatFits(CGSize(width: .zero, height: attributedString.size().height))
//                self.nameLabel.sizeToFit()
//            }
            
            self.emailLabel.text = data._ojra_Email
            
            if let image = data._ojraUploadImagesList.first?._imageAd, image.isNotEmpty {
                self.imageViewDesign.kf.setImage(with: URL(string: image))
            }
            
            guard let workingSetup = data._ojraWorkingSetUpList.first else { return }
            
            self.officeLabel.text = workingSetup._office
            self.websiteLabel.text = workingSetup._web
            
            let workTimeFrom = workingSetup._workingFrom
            let workTimeTo = workingSetup._workingTo
            
            /// 09:00:00.1234567
            /// HH:mm:ss.SSSSSZ
            
            if let timeFrom = workTimeFrom.convertFormatStringToDate("HH:mm:ss"),
               let timeTo = workTimeTo.convertFormatStringToDate("HH:mm:ss") {
                self.workTimeLabel.text = "\(timeFrom.formatDate("HH:mm")) - \(timeTo.formatDate("HH:mm"))"
            }
            
            if let timeFrom = workTimeFrom.convertFormatStringToDate("HH:mm:ss.SSS"),
               let timeTo = workTimeTo.convertFormatStringToDate("HH:mm:ss.SSS") {
                self.workTimeLabel.text = "\(timeFrom.formatDate("HH:mm")) - \(timeTo.formatDate("HH:mm"))"
            }
            
            let rate = workingSetup._rating
            self.rateLabel.text = "\(Int(rate))/5"
            self.rateCosmosView.rating = rate
            
            if let type = data._ojraRideTypeList.first {
                self.images = type._carTypeDetails
            }
            
            let isAdded = workingSetup._isItemAdded
            if self.isDirectory {
                self.addButton.isHidden   = isAdded
                self.removeButton.isHidden = !isAdded
            }
        }
    }
    
    private var images = [CarTypeDetails]() {
        didSet {
            self.imagesCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.registerNib(ImageCollectionViewCell.self)
    }
}

// MARK: - ACTIONS

extension LimousineCollectionViewCell {
    
    @IBAction func addToMyLimousineAction(_ sender: UIButton) {
        self.delegate?.didTapAddToMyLimousine(self, for: self.object)
    }
    
    @IBAction func removeToMyLimousineAction(_ sender: UIButton) {
        self.delegate?.didTapRemoveToMyLimousine(self, for: self.object)
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        self.delegate?.didTapCallLimousine(self, for: self.object)
    }
    
    @IBAction func openMapAction(_ sender: UIButton) {
        self.delegate?.didTapOpenMapLimousine(self, for: self.object)
    }
    
    @IBAction func openEmailAction(_ sender: UIButton) {
        self.delegate?.didTapOpenEmailLimousine(self, for: self.object)
    }
    
    @IBAction func openWebSiteAction(_ sender: UIButton) {
        self.delegate?.didTapOpenWebsiteLimousine(self, for: self.object)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension LimousineCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ImageCollectionViewCell.self, for: indexPath)
        
        let object = self.images[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsInRow: CGFloat = CGFloat(5)
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing * cellsInRow
        
        let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
        return CGSize(width: cellWidth, height: collectionView.height)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension LimousineCollectionViewCell {
    
    public func isDirectoryLimousine(_ status: Bool) {
        self.addButton.isHidden    = !status
        self.removeButton.isHidden = status
    }
    
    func cellConfiguration(_ color :UIColor) {
        self.nameLabel.textColor = color
    }
}

struct CellConfiguration {
    var textColor : UIColor
}
