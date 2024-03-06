//
//  BaseInfoCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/12/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Cosmos

protocol BaseInfoCollectionViewCellDelegate: AnyObject {
    
//    func didTapCall               (_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel)
//    func didTapOpenMap            (_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel)
//    func didTapOpenEmail          (_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel)
//    func didTapOpenWebsite        (_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel)
    func didTapAddToFavorite      (_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel)
    func didTapRemoveFromFavorite (_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel)
}

class BaseInfoCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imageViewDesign      : ImageViewDesign!
    
    @IBOutlet weak var nameLabel            : UILabel!
    
    @IBOutlet weak var officeLabel          : UILabel!
    
    @IBOutlet weak var workTimeLabel        : UILabel!
    
    @IBOutlet weak var emailLabel           : UILabel!
    
    @IBOutlet weak var websiteLabel         : UILabel!
    
    @IBOutlet weak var rateLabel            : UILabel!
    
    @IBOutlet weak var rateCosmosView       : CosmosView!
    
    @IBOutlet weak var addButton            : UIButton!
    
    @IBOutlet weak var removeButton         : UIButton!
    
    @IBOutlet weak var imagesCollectionView : UICollectionView!
    
    weak var delegate: BaseInfoCollectionViewCellDelegate?
    
    var config: BaseInfoCellConfig! {
        willSet {
            self.nameLabel.textColor = newValue.nameColor
            /// continue...
        
            self.addButton.setImage(newValue.favoriteImage, for: .normal)
            self.addButton.tintColor = .systemGray4

            self.removeButton.setImage(newValue.notFavoriteImage, for: .normal)
            self.removeButton.tintColor = .orange
            
        }
    }
    
    var isDirectory: Bool = true {
        willSet {
            self.isDirectory(newValue)
        }
    }
    
    private var formatToDate      = "HH:mm"
    private var formatTypeOneDate = "HH:mm:ss"
    private var formatTypeTwoDate = "HH:mm:ss.SSS"  /// 09:00:00.1234567      /// HH:mm:ss.SSSSSZ
    
    private var images = [BaseInfoImageModel]() {
        didSet {
            self.imagesCollectionView.reloadData()
        }
    }
    
    var object: BaseInfoDataModel! {
        willSet {
            guard let data = newValue else { return }
            
//            self.nameLabel.text        = data.name
//            self.nameLabel.sizeToFit()
            
            let attributedString            = NSAttributedString(string: data.name)
            self.nameLabel.attributedText   = attributedString
            self.nameLabel.sizeThatFits(CGSize(width: .zero, height: attributedString.size().height))
            
            self.emailLabel.text       = data.email
            self.officeLabel.text      = data.office
            self.websiteLabel.text     = data.website
            self.rateLabel.text        = "\(Int(data.rate))/5"
            self.rateCosmosView.rating = data.rate
            self.images                = data.images
 
            if let timeFrom = data.workingFrom.convertFormatStringToDate(formatTypeOneDate),
               let timeTo   = data.workingTo.convertFormatStringToDate(formatTypeOneDate) {
                self.workTimeLabel.text = "\(timeFrom.formatDate(formatToDate)) - \(timeTo.formatDate(formatToDate))"
            }
            
            if let timeFrom = data.workingFrom.convertFormatStringToDate(formatTypeTwoDate),
               let timeTo   = data.workingTo.convertFormatStringToDate(formatTypeTwoDate) {
                self.workTimeLabel.text = "\(timeFrom.formatDate(formatToDate)) - \(timeTo.formatDate(formatToDate))"
            }
            
            let isAdded = data.isFavorite
            if self.isDirectory {
                self.addButton.isHidden    = isAdded
                self.removeButton.isHidden = !isAdded
            }
            
            self.imageViewDesign.kf.setImage(with: URL(string: data.imageURL),placeholder: UIImage.qatar_avatar_ic)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagesCollectionView.delegate   = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.registerNib(BaseInfoImageCollectionViewCell.self)
    }
}

// MARK: - ACTIONS

extension BaseInfoCollectionViewCell {
    
    @IBAction func addToMyLimousineAction(_ sender: UIButton) {
        self.delegate?.didTapAddToFavorite(self, for: self.object)
    }
    
    @IBAction func removeToMyLimousineAction(_ sender: UIButton) {
        self.delegate?.didTapRemoveFromFavorite(self, for: self.object)
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        self.openCall(number: self.object.mobile)
    }
    
    @IBAction func openMapAction(_ sender: UIButton) {
        self.openGoogleMaps(map: self.object.locationURL)
    }
    
    @IBAction func openEmailAction(_ sender: UIButton) {
        self.openEmail(email: self.object.email)
    }
    
    @IBAction func openWebSiteAction(_ sender: UIButton) {
        self.openWebsite(link: self.object.website)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension BaseInfoCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueCell(BaseInfoImageCollectionViewCell.self, for: indexPath)
        let object  = self.images[indexPath.row]
        cell.object = object
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsInRow: CGFloat = CGFloat(5)
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat  = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing * cellsInRow
        
        let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
        return CGSize(width: cellWidth, height: collectionView.height)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension BaseInfoCollectionViewCell {
    
    public func isDirectory(_ status: Bool) {
        self.addButton.isHidden    = !status
        self.removeButton.isHidden = status
    }
    
    private func openCall(number : String) {
        var mobile = number
        if mobile.contains("/") {
            let mobiles = mobile.split(separator: "/")
            guard let phone = mobiles.first else { return }
            mobile = String(phone)
        }
        guard let callURL = URL(string: "\(mobile)") else { return }
        guard UIApplication.shared.canOpenURL(callURL) else { return }
        UIApplication.shared.open(callURL, options: [:])
    }
    
    private func openEmail(email :String) {
        guard let url = URL(string: "mailto:\(email)") else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    private func openWebsite(link :String) {
        guard let url = URL(string: link) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    private func openGoogleMaps(map :String) {
        guard let url = URL(string: "comgooglemaps://\(map)") else { return }
        
        guard UIApplication.shared.canOpenURL(url) else {
            guard let websiteURL = URL(string: "\(map)") else { return }
            UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
            return
        }
        UIApplication.shared.open(url)
    }
}
