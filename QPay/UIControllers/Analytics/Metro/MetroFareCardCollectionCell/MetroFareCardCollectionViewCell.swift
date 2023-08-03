//
//  MetroFareCardCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 21/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class MetroFareCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var type: MetroFareCard.Types!
    
    var details: MetroFareDetails? {
        willSet {
            guard let object = newValue else { return }
            self.cardNameLabel.text = object._cardName
            print(object._thumbnail)
            self.cardImageViewDesign.kf.setImage(with: URL(string: object._thumbnail))
        }
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var reusableKey: String = "Reusable"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.registerNib(MetroFareDetailsTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

// MARK: - TABLE VIEW DELEGATE

extension MetroFareCardCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let object = self.details else { return 0 }
        switch self.type {
        case .standard, .gold:
            return 1
            
        case .limited:
            let count = object._cardFareInformation.count
            let returnCount = count == 0 ? 0 : count + 1
            return returnCount
            
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let object = self.details else { return 0 }
        switch self.type {
        case .standard, .gold:
            return object._cardFareInformation.count + 1
            
        case .limited:
            let returnCount = section == tableView.numberOfSections - 1 ? 1 : object._cardFareInformation[section]._childFareList.count
            return returnCount
            
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cardDetails = self.details else { return UITableViewCell() }
        
        let cell = tableView.dequeueCell(MetroFareDetailsTableViewCell.self, for: indexPath)
        
        switch self.type {
        case .standard, .gold:
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                cell.keyLabel.text = self.reusableKey
                cell.valueLabel.text = cardDetails._reusable
                return cell
                
            } else {
                let cardInformation = cardDetails._cardFareInformation[indexPath.row]
                
                cell.keyLabel.text = cardInformation._fareType
                cell.valueLabel.text = cardInformation._amountWithCurrency
                cell.subValueLabel.isHidden = cardInformation._additionalNotes.isEmpty
                cell.subValueLabel.text = cardInformation._additionalNotes
                return cell
            }
            
        case .limited:
            cell.isSectionCell = indexPath.row == 0
            
            if indexPath.section == tableView.numberOfSections - 1 {
                cell.keyLabel.text = self.reusableKey
                cell.valueLabel.text = cardDetails._reusable
                return cell
                
            } else {
                let cardInformation = cardDetails._cardFareInformation[indexPath.section]
                
                if indexPath.row == 0 {
                    cell.keyLabel.text = cardInformation._fareType
                    cell.valueLabel.text = cardInformation._amountWithCurrency
                    return cell
                }
                
                let cardChild = cardInformation._childFareList[indexPath.row]
                
                cell.subValueLabel.isHidden = cardInformation._additionalNotes.isEmpty
                cell.subValueLabel.text = cardInformation._additionalNotes
                
                cell.keyLabel.text = cardChild._fareType
                cell.valueLabel.text = cardChild._amountWithCurrency
                return cell
            }
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 30
//        }
        return 40
    }
}

// MARK: - CUSTOM FUNCTIONS

extension MetroFareCardCollectionViewCell {
    
}

